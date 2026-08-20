using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BANKAPPPROJECT
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Redirect(Session["AccountNo"] == null ? "Login.aspx" : "Dashboard.aspx");
        }
    }
}