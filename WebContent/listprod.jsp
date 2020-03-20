<%@ page import="java.sql.*,java.net.URLEncoder"%>
<%@ page import="java.text.NumberFormat"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="header.jsp"%>
<%@ include file="jdbc.jsp"%>

<!DOCTYPE html>
<html>
<head>
<title>The Dream Vine</title>
</head>
<body>
	<h1>The Dream Vine</h1>

	<p>Browse dreams by category or search by product name:</p>

	<form method="get" action="listprod.jsp" autocomplete="off"
		style="color: black">
		<p align="left">
			<select size="1" name="categoryName">
				<option value="">Choose a category...</option>

				<%
					try {
						getConnection();
						String sql = "SELECT categoryName FROM category; ";
						PreparedStatement pstmt = con.prepareStatement(sql);
						ResultSet rst = pstmt.executeQuery();
						while (rst.next()) {
							out.print("<option>" + rst.getString(1) + "</option>");
						}

					} catch (Exception e) {
						System.err.print(e);
					}
				%>

			</select> <input type="text" name="productName" size="50"
				placeholder="Product name... (leave blank and click Search for all products)">
			<input type="submit" value="Search"> <input type="reset"
				value="Reset Form">
	</form>

	<%
		// Get product name to search for
		String category = request.getParameter("categoryName");
		String name = request.getParameter("productName");

		//Variable 'name' now contains the search string the user entered
		//Use it to build a query and print out the resultset. Make sure to use PreparedStatement!

		//Note: Forces loading of SQL Server driver
		try { // Load driver class
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		} catch (java.lang.ClassNotFoundException e) {
			out.println("ClassNotFoundException: " + e);
		}

		// Make the connection
		String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_vjack;";
		String uid = "vjack";
		String pw = "12304986";

		try (Connection con = DriverManager.getConnection(url, uid, pw);) {

			String sql = "SELECT productId, productName, productPrice, productImageURL, productDesc, categoryName "
					+ "FROM product " + "INNER JOIN category " + "ON product.categoryId = category.categoryId ";

			boolean productNameGiven = (name != null) && (!name.equals(""));
			boolean categoryNameGiven = (category != null) && (!category.equals(""));

			PreparedStatement pstmt = null;
			ResultSet rst = null;

			if (!productNameGiven && !categoryNameGiven) {
				pstmt = con.prepareStatement(sql);
				rst = pstmt.executeQuery();
			} else if (productNameGiven && !categoryNameGiven) {
				sql += " WHERE productName LIKE ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, "%" + name + "%");
				rst = pstmt.executeQuery();
				out.println("<p>Results for '" + name + "':</p>");
			} else if (!productNameGiven && categoryNameGiven) {
				sql += " WHERE categoryName LIKE ? ";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, "%" + category + "%");
				rst = pstmt.executeQuery();
				out.println("<p>Results for '" + category + "':</p>");
			} else if (productNameGiven && categoryNameGiven) {
				sql += " WHERE productName LIKE ? AND categoryName LIKE ? ";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, "%" + name + "%");
				pstmt.setString(2, "%" + category + "%");
				rst = pstmt.executeQuery();
				out.println("<p>Results for '" + name + "' in '" + category + "':</p>");
			}

			//Table showing ResultSet
			out.print("<table>");
			out.print("<table style='border-collapse: collapse'>");

			NumberFormat currFormat = NumberFormat.getCurrencyInstance();
			while (rst.next()) {
				out.print("<tr>");
				int r = (int) (150 + Math.random() * (255 - 150));
				int g = (int) (150 + Math.random() * (255 - 150));
				int b = (int) (150 + Math.random() * (255 - 150));

				String addCartLink = "addcart.jsp?id=" + rst.getString("productId") + "&name="
						+ rst.getString("productName") + "&price=" + rst.getDouble("productPrice");

				String productDetailLink = "product.jsp?id=" + rst.getString("productId");
				String prod = rst.getString("productName");

				String prodImg = rst.getString("productImageURL");

				out.print(displayProduct(rst, r, g, b));
				if (rst.next())
					out.print(displayProduct(rst, r, g, b));
				out.print("</tr>");
			}
			out.print("</table>");

		} catch (SQLException e) {
			out.print("<p>Error. " + e + " </p>");
		}
	%>
	<%!String displayProduct(ResultSet rst, int r, int g, int b) throws SQLException {
		NumberFormat currFormat = NumberFormat.getCurrencyInstance();
		String addCartLink = "addcart.jsp?id=" + rst.getString("productId") + "&name=" + rst.getString("productName")
				+ "&price=" + rst.getDouble("productPrice");

		String productDetailLink = "product.jsp?id=" + rst.getString("productId");
		String prod = rst.getString("productName");

		String prodImg = rst.getString("productImageURL");

		String averageReviewSQL = "SELECT AVG(reviewRating) FROM review WHERE productId = ?"; //TODO: query for average review rating
		PreparedStatement getAvg = con.prepareStatement(averageReviewSQL);
		String currentId = rst.getString("productId");
		getAvg.setString(1, currentId);
		ResultSet avgRating = getAvg.executeQuery();
		double avg = 0;
		String avgString = "";
		while (avgRating.next()) {
			avg = avgRating.getInt(1);
			avgString += avg;
			if (avg == 0) {
				avgString = "-";
			}
		}

		String rtrn = "<td><div class='container'><a href='" + productDetailLink + "'><img src='" + prodImg
				+ "'></a></div></td>" + "<td><a href='" + productDetailLink + "' style='font-size:20px;color:rgb(" + r
				+ "," + g + "," + b + ")'><b>" + rst.getString("productName") + "</b></a>"
				+ "<br><span style='font-size:14px'>Category: " + rst.getString("categoryName") + "<br>Rating: "
				+ avgString + "/5" + "<br>CAD" + currFormat.format(rst.getDouble("productPrice")) + "<br><a href='"
				+ addCartLink + "'><button>Add to Cart</button></a>" + "</td>";
		return rtrn;
	}%>

</body>
</html>