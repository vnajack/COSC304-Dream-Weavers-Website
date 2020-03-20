<%@ page import="java.sql.*"%>
<link rel="stylesheet" type="text/css" href="style.css" />
<body background="twinklingStars.gif">
	<a href="index.jsp"> <img src="shopLogo.png" alt="Logo"
		style="width: 350px; height: 280px;">
	</a>
	<div class="topnav" id="myTopnav">
		<a href="index.jsp" class="active">Home</a>
		<div class="dropdown">
			<button class="dropbtn" onclick="window.location.href='listprod.jsp'">Shop</button>
			<div class="dropdown-content">
				<a href="listprod.jsp">List Products</a> <a href="showcart.jsp">Shopping
					Cart</a>
			</div>
		</div>
		<%
			boolean loggedIn = session.getAttribute("authenticatedUser") == null ? false : true;
			if (loggedIn) {
				out.println("<div class=\"dropdown\">");
				out.println("<button class=\"dropbtn\">Admin</button>");
				out.println("<div class=\"dropdown-content\">");
				out.println("<a href=\"admin.jsp\">Sales Report</a>" + "<a href=\"listorder.jsp\">List All Orders</a>"
						+ "<a href=\"listcustomer.jsp\">List All Customers</a>"
						+ "<a href=\"productsadmin.jsp\">Update or Delete Products</a>"
						+ "<a href=\"addproduct.jsp\">Add New Product</a></div></div>");
			}
		%>

		<div class="topnav-right">
			<%
				if (!loggedIn) {
					out.print("<a href='createCustomer.jsp'>Create an Account</a>" + "<a href='login.jsp'>Log in</a>");
				} else {
					String userName = (String) session.getAttribute("authenticatedUser");
					String custFirstName = "";

					if (userName != null) {
						String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_vjack;";
						String uid = "vjack";
						String pw = "12304986";

						String getName = "SELECT firstName FROM customer WHERE userId = ?";

						try (Connection con = DriverManager.getConnection(url, uid, pw);) {

							PreparedStatement pstmt = con.prepareStatement(getName);
							pstmt.setString(1, userName);
							ResultSet rst = pstmt.executeQuery();
							while (rst.next()) {
								custFirstName = rst.getString("firstName");
							}

						} catch (SQLException e) {
							out.print("<p>Error. " + e + "</p>");
						}

						out.print("<div class=\"dropdown\">" + "<button class=\"dropbtn\"> " + custFirstName
								+ "\'s Account</button>" + "<div class=\"dropdown-content\">"
								+ "<a href=\"customer.jsp\">Customer Information</a>"
								+ "<a href=\"orderhistory.jsp\">Order History</a>" + "</div>" + "</div>"
								+ "<a href='logout.jsp'>Log out</a>");

					}
				}
			%>

		</div>
	</div>
	<br>
</body>
