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
    public partial class MyDepositsWithdrawals : Page
    {
        string cs = WebConfigurationManager.ConnectionStrings["bankdb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AccountNo"] == null) { Response.Redirect("Login.aspx"); return; }
        }

        protected void btnList_Click(object sender, EventArgs e)
        {
            // Validate dates
            DateTime from, to;
            if (!DateTime.TryParse(txtFrom.Text, out from))
            { Show("Please enter a valid From date.", false); return; }
            if (!DateTime.TryParse(txtTo.Text, out to))
            { Show("Please enter a valid To date.", false); return; }
            if (from > DateTime.Today)
            { Show("From date must not be a future date.", false); return; }
            if (to > DateTime.Today)
            { Show("To date must not be a future date.", false); return; }
            if (from > to)
            { Show("From date must be earlier than To date.", false); return; }

            // Set To date to end of day
            to = to.AddDays(1).AddSeconds(-1);

            int acct = (int)Session["AccountNo"];
            string type = ddlType.SelectedValue;

            string query;
            if (type == "All")
                query = @"SELECT TxnDate, TxnType, Amount 
                          FROM Transactions 
                          WHERE AccountNo=@a 
                          AND TxnType IN ('Deposit','Withdraw')
                          AND TxnDate BETWEEN @from AND @to
                          ORDER BY TxnID ASC";
            else
                query = @"SELECT TxnDate, TxnType, Amount 
                          FROM Transactions 
                          WHERE AccountNo=@a 
                          AND TxnType=@t
                          AND TxnDate BETWEEN @from AND @to
                          ORDER BY TxnID ASC";

            using (var db = new SqlConnection(cs))
            {
                db.Open();
                using (var da = new SqlDataAdapter(query, db))
                {
                    da.SelectCommand.Parameters.AddWithValue("@a", acct);
                    da.SelectCommand.Parameters.AddWithValue("@from", from);
                    da.SelectCommand.Parameters.AddWithValue("@to", to);
                    if (type != "All")
                        da.SelectCommand.Parameters.AddWithValue("@t", type);

                    var dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count == 0)
                    {
                        Show("No transactions found for the selected date range and type.", false);
                        pnlResults.Visible = false;
                        return;
                    }

                    rptResults.DataSource = dt;
                    rptResults.DataBind();
                    pnlResults.Visible = true;
                    lblMsg.Text = "";
                }
            }
        }

        void Show(string m, bool ok)
        {
            lblMsg.Text = "<div class='msg " + (ok ? "msg-ok" : "msg-error") + "'>" + m + "</div>";
        }
    }
}