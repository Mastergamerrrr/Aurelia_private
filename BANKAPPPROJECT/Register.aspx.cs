using System;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Web.UI;

namespace BANKAPPPROJECT
{
    public partial class Register : Page
    {
        string cs = WebConfigurationManager.ConnectionStrings["bankdb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e) { }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string u = txtUsername.Text.Trim();
            string fn = txtFullName.Text.Trim();
            string em = txtEmail.Text.Trim();
            string p = txtPassword.Text;
            string c = txtConfirm.Text;

            // Validation
            if (u.Length == 0 || fn.Length == 0 || p.Length == 0)
            { Show("All required fields must be filled.", false); return; }
            if (p.Length < 6)
            { Show("Password must be at least 6 characters.", false); return; }
            if (p != c)
            { Show("Passwords do not match.", false); return; }

            using (var db = new SqlConnection(cs))
            {
                db.Open();

                // Check if username already exists
                using (var cmd = db.CreateCommand())
                {
                    cmd.CommandText = "SELECT COUNT(*) FROM Users WHERE Username=@u";
                    cmd.Parameters.AddWithValue("@u", u);
                    if ((int)cmd.ExecuteScalar() > 0)
                    { Show("Username already taken.", false); return; }
                }

                // Insert new user
                using (var cmd = db.CreateCommand())
                {
                    cmd.CommandText = "INSERT INTO Users (Username, PasswordHash, FullName, Email, Role, Balance) " +
                                      "VALUES (@u, @p, @f, @e, 'User', 0)";
                    cmd.Parameters.AddWithValue("@u", u);
                    cmd.Parameters.AddWithValue("@p", Security.Hash(p));
                    cmd.Parameters.AddWithValue("@f", fn);
                    cmd.Parameters.AddWithValue("@e", em);
                    cmd.ExecuteNonQuery();
                }
            }
            Show("Account created! You may now <a href='Login.aspx'>login</a>.", true);
        }

        void Show(string m, bool ok)
        {
            lblMsg.Text = "<div class='msg " + (ok ? "ok" : "err") + "'>" + m + "</div>";
        }
    }
}