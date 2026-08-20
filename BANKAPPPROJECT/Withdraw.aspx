<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="Withdraw.aspx.cs" Inherits="BANKAPPPROJECT.Withdraw" %>

<asp:Content ID="c1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Withdraw</h2>
    <p>Current Balance: <span class="balance">PHP <asp:Label ID="lblBal" runat="server" /></span></p>
    <label>Amount (Min 100, Max 2,000, multiples of 100)</label>
    <asp:TextBox ID="txtAmount" runat="server" TextMode="Number" />
    <asp:Button ID="btnWithdraw" runat="server" Text="Withdraw" CssClass="btn" OnClick="btnWithdraw_Click" />
    <asp:Label ID="lblMsg" runat="server" />
</asp:Content>