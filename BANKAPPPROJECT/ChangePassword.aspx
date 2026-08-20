<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ChangePassword.aspx.cs" Inherits="BANKAPPPROJECT.ChangePassword" %>
<asp:Content ID="c1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Change Password</h2>
    <label>Current Password</label>
    <asp:TextBox ID="txtOld" runat="server" TextMode="Password" />
    <label>New Password</label>
    <asp:TextBox ID="txtNew" runat="server" TextMode="Password" />
    <label>Confirm New Password</label>
    <asp:TextBox ID="txtConfirm" runat="server" TextMode="Password" />
    <asp:Button ID="btnChange" runat="server" Text="Update Password" CssClass="btn" OnClick="btnChange_Click" />
    <asp:Label ID="lblMsg" runat="server" />
</asp:Content>
