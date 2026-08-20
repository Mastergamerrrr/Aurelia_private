using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Web.Configuration;


namespace BANKAPPPROJECT
{
    public partial class Dashboard : Page
    {
        string cs = WebConfigurationManager.ConnectionStrings["bankdb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AccountNo"] == null) { Response.Redirect("Login.aspx"); return; }
            int acct = (int)Session["AccountNo"];

            using (var db = new SqlConnection(cs))
            {
                db.Open();

                // ── Account info ──────────────────────────────────────────
                string fullName = "", dateReg = "", bal = "", acctNo = "";
                using (var cmd = db.CreateCommand())
                {
                    cmd.CommandText = "SELECT AccountNo, FullName, DateRegistered, Balance FROM Users WHERE AccountNo=@a";
                    cmd.Parameters.AddWithValue("@a", acct);
                    using (var r = cmd.ExecuteReader())
                    {
                        if (r.Read())
                        {
                            acctNo = r.GetInt32(0).ToString();
                            fullName = r.GetString(1);
                            dateReg = r.GetDateTime(2).ToString("MMMM dd, yyyy hh:mm tt");
                            bal = "PHP " + r.GetDecimal(3).ToString("N2");
                        }
                    }
                }

                lblAcct.Text = acctNo;
                lblBal.Text = bal;
                lblAcct2.Text = acctNo;
                lblName.Text = fullName;
                lblDate.Text = dateReg;
                lblBal2.Text = bal;

                // ── Total sent (all-time) ─────────────────────────────────
                using (var cmd = db.CreateCommand())
                {
                    cmd.CommandText = "SELECT ISNULL(SUM(Amount),0) FROM CloudMoney WHERE SenderAcctNo=@a";
                    cmd.Parameters.AddWithValue("@a", acct);
                    decimal totalSent = (decimal)cmd.ExecuteScalar();
                    lblSent.Text = "PHP " + totalSent.ToString("N2");
                    lblSent2.Text = "PHP " + totalSent.ToString("N2");
                }

                // ── This Month stats ──────────────────────────────────────
                DateTime now = DateTime.Now;
                DateTime curStart = new DateTime(now.Year, now.Month, 1);
                DateTime curEnd = curStart.AddMonths(1).AddSeconds(-1);
                DateTime prevStart = curStart.AddMonths(-1);
                DateTime prevEnd = curStart.AddSeconds(-1);

                decimal curIn = 0, curOut = 0;
                decimal prevIn = 0, prevOut = 0;

                // Current month
                using (var cmd = db.CreateCommand())
                {
                    cmd.CommandText = @"
                        SELECT
                            ISNULL(SUM(CASE WHEN TxnType IN ('Deposit','Receive') THEN Amount ELSE 0 END), 0) AS MoneyIn,
                            ISNULL(SUM(CASE WHEN TxnType IN ('Withdraw','Send')   THEN Amount ELSE 0 END), 0) AS MoneyOut
                        FROM Transactions
                        WHERE AccountNo = @a
                          AND TxnDate BETWEEN @s AND @e";
                    cmd.Parameters.AddWithValue("@a", acct);
                    cmd.Parameters.AddWithValue("@s", curStart);
                    cmd.Parameters.AddWithValue("@e", curEnd);
                    using (var r = cmd.ExecuteReader())
                    {
                        if (r.Read()) { curIn = r.GetDecimal(0); curOut = r.GetDecimal(1); }
                    }
                }

                // Previous month
                using (var cmd = db.CreateCommand())
                {
                    cmd.CommandText = @"
                        SELECT
                            ISNULL(SUM(CASE WHEN TxnType IN ('Deposit','Receive') THEN Amount ELSE 0 END), 0) AS MoneyIn,
                            ISNULL(SUM(CASE WHEN TxnType IN ('Withdraw','Send')   THEN Amount ELSE 0 END), 0) AS MoneyOut
                        FROM Transactions
                        WHERE AccountNo = @a
                          AND TxnDate BETWEEN @s AND @e";
                    cmd.Parameters.AddWithValue("@a", acct);
                    cmd.Parameters.AddWithValue("@s", prevStart);
                    cmd.Parameters.AddWithValue("@e", prevEnd);
                    using (var r = cmd.ExecuteReader())
                    {
                        if (r.Read()) { prevIn = r.GetDecimal(0); prevOut = r.GetDecimal(1); }
                    }
                }

                // Compute % change
                string inPct = FormatPct(curIn, prevIn);
                string outPct = FormatPct(curOut, prevOut);
                bool inUp = curIn >= prevIn;
                bool outUp = curOut >= prevOut;   // "up" means more spending

                lblMoneyIn.Text = "PHP " + curIn.ToString("N2");
                lblMoneyOut.Text = "PHP " + curOut.ToString("N2");
                lblInPct.Text = inPct;
                lblOutPct.Text = outPct;
                // Pass direction as CSS class via hidden labels read by JS
                lblInDir.Text = inUp ? "up" : "down";
                lblOutDir.Text = outUp ? "up" : "down";

                // ── Notifications ─────────────────────────────────────────
                using (var da = new SqlDataAdapter(
                    "SELECT TOP 5 SenderAcctNo, Amount, SendDate FROM CloudMoney WHERE ReceiverAcctNo=@a ORDER BY SendID DESC", db))
                {
                    da.SelectCommand.Parameters.AddWithValue("@a", acct);
                    var dt = new DataTable();
                    da.Fill(dt);
                    if (dt.Rows.Count > 0) { pnlNotif.Visible = true; rptNotif.DataSource = dt; rptNotif.DataBind(); }
                }

                // ── Last 10 transactions ──────────────────────────────────
                using (var da = new SqlDataAdapter(
                    "SELECT TOP 10 TxnDate, TxnType, Amount, Balance FROM Transactions WHERE AccountNo=@a ORDER BY TxnID DESC", db))
                {
                    da.SelectCommand.Parameters.AddWithValue("@a", acct);
                    var dt = new DataTable();
                    da.Fill(dt);
                    gvTxn.DataSource = dt;
                    gvTxn.DataBind();
                }
            }
        }

        // Returns a formatted percentage string like "+12%" or "-5%"
        static string FormatPct(decimal cur, decimal prev)
        {
            if (prev == 0)
                return cur > 0 ? "+100%" : "0%";
            decimal pct = Math.Round((cur - prev) / prev * 100, 0);
            return (pct >= 0 ? "+" : "") + pct.ToString("0") + "%";
        }
    }
}