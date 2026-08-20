<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Deposit.aspx.cs" Inherits="BANKAPPPROJECT.Deposit" %>
<asp:Content ID="c1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Deposit</h2>
    <p>Current Balance: <span class="balance">PHP <asp:Label ID="lblBal" runat="server" /></span></p>
    <label>Amount (Min 100, Max 2,000, multiples of 100)</label>
    <asp:TextBox ID="txtAmount" runat="server" TextMode="Number" />
    <asp:Button ID="btnDeposit" runat="server" Text="Deposit" CssClass="btn" OnClick="btnDeposit_Click" />
    <asp:Label ID="lblMsg" runat="server" />
    <p style="margin-top:16px; color:#666; font-size:13px;">Total balance cannot exceed PHP 10,000.00.</p>
</asp:Content>
