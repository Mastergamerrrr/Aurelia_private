using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BANKAPPPROJECT
{
    public partial class Login : Page
    {
        string cs = WebConfigurationManager.ConnectionStrings["bankdb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e) { }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string u = txtUsername.Text.Trim();
            string p = txtPassword.Text;

            using (var db = new SqlConnection(cs))
            {
                db.Open();
                using (var cmd = db.CreateCommand())
                {
                    cmd.CommandText = "SELECT AccountNo, FullName, Role FROM Users WHERE Username=@u AND PasswordHash=@p";
                    cmd.Parameters.AddWithValue("@u", u);
                    cmd.Parameters.AddWithValue("@p", Security.Hash(p));
                    using (var r = cmd.ExecuteReader())
                    {
                        if (r.Read())
                        {
                            Session["AccountNo"] = r.GetInt32(0);
                            Session["FullName"] = r.GetString(1);
                            Session["Username"] = u;
                            Session["Role"] = r.GetString(2);
                            Response.Redirect(Session["Role"].ToString() == "Admin" ? "Admin.aspx" : "Dashboard.aspx");
                            return;
                        }
                    }
                }
            }
            lblMsg.Text = "<div class='msg'>Invalid username or password.</div>";
        }
    }
}