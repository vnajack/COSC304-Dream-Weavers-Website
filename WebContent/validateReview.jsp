<%@ page language="java" import="java.io.*,java.util.Date,java.sql.*"%>
<%@ page language="java" import="java.text.SimpleDateFormat"%>
<%@ include file="jdbc.jsp"%>
<%
	String reviewWritten = null;
	session = request.getSession(true);
	try {
		reviewWritten = validateReview(out, request, session);
	} catch (IOException e) {
		System.err.println(e);
	}
	if (reviewWritten == null) {
		response.sendRedirect("orderhistory.jsp"); //successfully wrote a review
	} else {
		response.sendRedirect("orderhistory.jsp"); //failed to write a review
	}
%>

<%!String validateReview(JspWriter out, HttpServletRequest request, HttpSession session) throws IOException {
		String productId = request.getParameter("productId");
		String userId = request.getParameter("authenticatedUser");
		String reviewRating = request.getParameter("reviewRating");
		String reviewDate = request.getParameter("reviewDate");
		String reviewComment = request.getParameter("reviewComment");
		String result = null;

		if (reviewRating == null || reviewRating.length() == 0 || reviewDate == null || reviewDate.length() == 0) {
			result = "invalid";
			return result;
		}
		try {
			getConnection();

			int custId = 0;
			String sqlCustId = "SELECT customerId from customer WHERE userid = ?;";
			PreparedStatement pstmtCustId = con.prepareStatement(sqlCustId);
			pstmtCustId.setInt(1, Integer.parseInt(userId));
			ResultSet rstCustId = pstmtCustId.executeQuery();
			while (rstCustId.next()) {
				custId = rstCustId.getInt(1);
			}

			//see if this customer has written a review for this product before
			String sql = "SELECT customerId, productId FROM review WHERE productId = ? AND customerId = ? ";
			PreparedStatement pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, Integer.parseInt(productId));
			pstmt.setInt(2, custId);
			ResultSet rst = pstmt.executeQuery();
			if (rst.first()) {
				return result;
			} else {
				//change date data type
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				Date rDate = null;
				try {
					rDate = sdf.parse(reviewDate);
				} catch (Exception e) {
				}
				java.sql.Date sqlRDate = new java.sql.Date(rDate.getTime());
				//SQL insert
				String insert = "INSERT INTO review (reviewRating, reviewDate, customerId, productId, reviewComment) VALUES (?, ?, ?, ?, ?) ";
				PreparedStatement pstmtInsert = con.prepareStatement(insert);
				pstmtInsert.setInt(1, Integer.parseInt(reviewRating));
				pstmtInsert.setDate(2, sqlRDate);
				pstmtInsert.setInt(3, custId);
				pstmtInsert.setInt(4, Integer.parseInt(productId));
				pstmtInsert.setString(5, reviewComment);
				pstmtInsert.executeUpdate();
			}
		} catch (SQLException e) {
			out.print("<p>Error." + e + "</p>");
		} finally {
			closeConnection();
		}
		if (result.equals("invalid")) {
			session.setAttribute("createMessage", "<p>Invalid form entry. Please try again.</p>");
		} else if (result.equals("already")) {
			session.setAttribute("createMessage", "<p>You have already written a review for this product. Thank you for your review.");
		} else {
			session.removeAttribute("createMessage");
			session.setAttribute("reviewWritten", reviewRating);
		}
		return result;
	}%>