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
    public partial class ChangePassword : Page
    {
        string cs = WebConfigurationManager.ConnectionStrings["bankdb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AccountNo"] == null) { Response.Redirect("Login.aspx"); return; }
        }

        protected void btnChange_Click(object sender, EventArgs e)
        {
            string oldP = txtOld.Text;
            string newP = txtNew.Text;
            string conf = txtConfirm.Text;

            // Validation
            if (newP.Length < 6)
            { Show("New password must be at least 6 characters.", false); return; }
            if (newP != conf)
            { Show("Passwords do not match.", false); return; }

            int acct = (int)Session["AccountNo"];
            using (var db = new SqlConnection(cs))
            {
                db.Open();

                // Verify current password
                using (var cmd = db.CreateCommand())
                {
                    cmd.CommandText = "SELECT PasswordHash FROM Users WHERE AccountNo=@a";
                    cmd.Parameters.AddWithValue("@a", acct);
                    var stored = (string)cmd.ExecuteScalar();
                    if (stored != Security.Hash(oldP))
                    { Show("Current password is incorrect.", false); return; }
                }

                // Update to new password
                using (var cmd = db.CreateCommand())
                {
                    cmd.CommandText = "UPDATE Users SET PasswordHash=@p WHERE AccountNo=@a";
                    cmd.Parameters.AddWithValue("@p", Security.Hash(newP));
                    cmd.Parameters.AddWithValue("@a", acct);
                    cmd.ExecuteNonQuery();
                }
            }
            Show("Password updated successfully.", true);
            txtOld.Text = txtNew.Text = txtConfirm.Text = "";
        }

        void Show(string m, bool ok)
        {
            lblMsg.Text = "<div class='msg " + (ok ? "msg-ok" : "msg-error") + "'>" + m + "</div>";
        }
    }
}