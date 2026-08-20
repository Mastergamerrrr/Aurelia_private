using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Web.Configuration;

namespace BANKAPPPROJECT
{
    public partial class SendMoney : Page
    {
        string cs = WebConfigurationManager.ConnectionStrings["bankdb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AccountNo"] == null) { Response.Redirect("Login.aspx"); return; }
        }

        // Step 1 - Find recipient account
        protected void btnFind_Click(object sender, EventArgs e)
        {
            int recipientAcct;
            if (!int.TryParse(txtRecipientAcct.Text, out recipientAcct))
            { ShowFind("Please enter a valid account number.", false); return; }

            int myAcct = (int)Session["AccountNo"];
            if (recipientAcct == myAcct)
            { ShowFind("You cannot send money to your own account.", false); return; }

            using (var db = new SqlConnection(cs))
            {
                db.Open();
                using (var cmd = db.CreateCommand())
                {
                    cmd.CommandText = "SELECT AccountNo, FullName FROM Users WHERE AccountNo=@a";
                    cmd.Parameters.AddWithValue("@a", recipientAcct);
                    using (var r = cmd.ExecuteReader())
                    {
                        if (r.Read())
                        {
                            lblRAcct.Text = r.GetInt32(0).ToString();
                            lblRName.Text = r.GetString(1);
                            pnlRecipient.Visible = true;
                            lblFindMsg.Text = "";
                        }
                        else
                        {
                            pnlRecipient.Visible = false;
                            ShowFind("Account not found. Please check the account number.", false);
                        }
                    }
                }
            }
        }

        // Step 2 - Send money
        protected void btnSend_Click(object sender, EventArgs e)
        {
            decimal amt;
            if (!decimal.TryParse(txtAmount.Text, out amt))
            { ShowMsg("Enter a valid amount.", false); return; }
            if (amt < 100)
            { ShowMsg("Minimum amount is PHP 100.00.", false); return; }
            if (amt > 2000)
            { ShowMsg("Maximum amount per transaction is PHP 2,000.00.", false); return; }
            if (amt % 100 != 0)
            { ShowMsg("Amount must be divisible by 100.", false); return; }

            int myAcct = (int)Session["AccountNo"];
            int recipientAcct = int.Parse(lblRAcct.Text);

            using (var db = new SqlConnection(cs))
            {
                db.Open();

                // Verify password
                using (var cmd = db.CreateCommand())
                {
                    cmd.CommandText = "SELECT PasswordHash FROM Users WHERE AccountNo=@a";
                    cmd.Parameters.AddWithValue("@a", myAcct);
                    var stored = (string)cmd.ExecuteScalar();
                    if (stored != Security.Hash(txtPassword.Text))
                    { ShowMsg("Incorrect password. Please try again.", false); return; }
                }

                // Check sender balance
                decimal senderBal;
                using (var cmd = db.CreateCommand())
                {
                    cmd.CommandText = "SELECT Balance FROM Users WHERE AccountNo=@a";
                    cmd.Parameters.AddWithValue("@a", myAcct);
                    senderBal = (decimal)cmd.ExecuteScalar();
                }
                if (amt > senderBal)
                { ShowMsg("Insufficient funds. Current balance: PHP " + senderBal.ToString("N2"), false); return; }

                // Check receiver balance cap
                decimal receiverBal;
                using (var cmd = db.CreateCommand())
                {
                    cmd.CommandText = "SELECT Balance FROM Users WHERE AccountNo=@a";
                    cmd.Parameters.AddWithValue("@a", recipientAcct);
                    receiverBal = (decimal)cmd.ExecuteScalar();
                }
                if (receiverBal + amt > 10000)
                { ShowMsg("Recipient's balance would exceed PHP 10,000.00 limit.", false); return; }

                decimal newSenderBal = senderBal - amt;
                decimal newReceiverBal = receiverBal + amt;

                // Execute transaction
                using (var tx = db.BeginTransaction())
                {
                    // Deduct from sender
                    using (var cmd = db.CreateCommand())
                    {
                        cmd.Transaction = tx;
                        cmd.CommandText = "UPDATE Users SET Balance=@b WHERE AccountNo=@a";
                        cmd.Parameters.AddWithValue("@b", newSenderBal);
                        cmd.Parameters.AddWithValue("@a", myAcct);
                        cmd.ExecuteNonQuery();
                    }
                    // Add to receiver
                    using (var cmd = db.CreateCommand())
                    {
                        cmd.Transaction = tx;
                        cmd.CommandText = "UPDATE Users SET Balance=@b WHERE AccountNo=@a";
                        cmd.Parameters.AddWithValue("@b", newReceiverBal);
                        cmd.Parameters.AddWithValue("@a", recipientAcct);
                        cmd.ExecuteNonQuery();
                    }
                    // Record in Transactions for sender
                    using (var cmd = db.CreateCommand())
                    {
                        cmd.Transaction = tx;
                        cmd.CommandText = "INSERT INTO Transactions(AccountNo,TxnType,Amount,Balance,SentToAcctNo) VALUES(@a,'Send',@am,@b,@r)";
                        cmd.Parameters.AddWithValue("@a", myAcct);
                        cmd.Parameters.AddWithValue("@am", amt);
                        cmd.Parameters.AddWithValue("@b", newSenderBal);
                        cmd.Parameters.AddWithValue("@r", recipientAcct);
                        cmd.ExecuteNonQuery();
                    }
                    // Record in Transactions for receiver
                    using (var cmd = db.CreateCommand())
                    {
                        cmd.Transaction = tx;
                        cmd.CommandText = "INSERT INTO Transactions(AccountNo,TxnType,Amount,Balance,ReceivedFromAcctNo) VALUES(@a,'Receive',@am,@b,@s)";
                        cmd.Parameters.AddWithValue("@a", recipientAcct);
                        cmd.Parameters.AddWithValue("@am", amt);
                        cmd.Parameters.AddWithValue("@b", newReceiverBal);
                        cmd.Parameters.AddWithValue("@s", myAcct);
                        cmd.ExecuteNonQuery();
                    }
                    // Record in CloudMoney table
                    using (var cmd = db.CreateCommand())
                    {
                        cmd.Transaction = tx;
                        cmd.CommandText = "INSERT INTO CloudMoney(SenderAcctNo,ReceiverAcctNo,Amount,SenderBalance) VALUES(@s,@r,@am,@b)";
                        cmd.Parameters.AddWithValue("@s", myAcct);
                        cmd.Parameters.AddWithValue("@r", recipientAcct);
                        cmd.Parameters.AddWithValue("@am", amt);
                        cmd.Parameters.AddWithValue("@b", newSenderBal);
                        cmd.ExecuteNonQuery();
                    }
                    tx.Commit();
                }
                ShowMsg("Successfully sent PHP " + amt.ToString("N2") + " to " + lblRName.Text + "!", true);
                txtAmount.Text = "";
                txtPassword.Text = "";
            }
        }

        void ShowFind(string m, bool ok)
        {
            lblFindMsg.Text = "<div class='msg " + (ok ? "msg-ok" : "msg-error") + "'>" + m + "</div>";
        }
        void ShowMsg(string m, bool ok)
        {
            lblMsg.Text = "<div class='msg " + (ok ? "msg-ok" : "msg-error") + "'>" + m + "</div>";
        }
    }
}