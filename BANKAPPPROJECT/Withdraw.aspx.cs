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
    public partial class Withdraw : Page
    {
        string cs = WebConfigurationManager.ConnectionStrings["bankdb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AccountNo"] == null) { Response.Redirect("Login.aspx"); return; }
            if (!IsPostBack) LoadBalance();
        }

        void LoadBalance()
        {
            int acct = (int)Session["AccountNo"];
            using (var db = new SqlConnection(cs))
            {
                db.Open();
                using (var cmd = db.CreateCommand())
                {
                    cmd.CommandText = "SELECT Balance FROM Users WHERE AccountNo=@a";
                    cmd.Parameters.AddWithValue("@a", acct);
                    lblBal.Text = ((decimal)cmd.ExecuteScalar()).ToString("N2");
                }
            }
        }

        protected void btnWithdraw_Click(object sender, EventArgs e)
        {
            decimal amt;
            if (!decimal.TryParse(txtAmount.Text, out amt))
            { Show("Enter a valid amount.", false); return; }
            if (amt < 100)
            { Show("Minimum withdrawal is PHP 100.00.", false); return; }
            if (amt > 2000)
            { Show("Maximum withdrawal per transaction is PHP 2,000.00.", false); return; }
            if (amt % 100 != 0)
            { Show("Amount must be divisible by 100.", false); return; }

            int acct = (int)Session["AccountNo"];
            using (var db = new SqlConnection(cs))
            {
                db.Open();
                decimal cur;

                // Get current balance
                using (var cmd = db.CreateCommand())
                {
                    cmd.CommandText = "SELECT Balance FROM Users WHERE AccountNo=@a";
                    cmd.Parameters.AddWithValue("@a", acct);
                    cur = (decimal)cmd.ExecuteScalar();
                }

                // Check sufficient funds
                if (amt > cur)
                {
                    Show("Insufficient funds. Current balance: PHP " + cur.ToString("N2"), false);
                    LoadBalance(); return;
                }

                decimal newBal = cur - amt;

                // Update balance and record transaction
                using (var tx = db.BeginTransaction())
                {
                    using (var cmd = db.CreateCommand())
                    {
                        cmd.Transaction = tx;
                        cmd.CommandText = "UPDATE Users SET Balance=@b WHERE AccountNo=@a";
                        cmd.Parameters.AddWithValue("@b", newBal);
                        cmd.Parameters.AddWithValue("@a", acct);
                        cmd.ExecuteNonQuery();
                    }
                    using (var cmd = db.CreateCommand())
                    {
                        cmd.Transaction = tx;
                        cmd.CommandText = "INSERT INTO Transactions(AccountNo,TxnType,Amount,Balance) VALUES(@a,'Withdraw',@am,@b)";
                        cmd.Parameters.AddWithValue("@a", acct);
                        cmd.Parameters.AddWithValue("@am", amt);
                        cmd.Parameters.AddWithValue("@b", newBal);
                        cmd.ExecuteNonQuery();
                    }
                    tx.Commit();
                }
                Show("Withdrew PHP " + amt.ToString("N2") + ". New balance: PHP " + newBal.ToString("N2"), true);
                txtAmount.Text = "";
            }
            LoadBalance();
        }

        void Show(string m, bool ok)
        {
            lblMsg.Text = "<div class='msg " + (ok ? "msg-ok" : "msg-error") + "'>" + m + "</div>";
        }
    }
}