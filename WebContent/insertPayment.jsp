<%@ page language="java" import="java.io.*,java.util.Date,java.sql.*"%>
<%@ page language="java" import="java.text.SimpleDateFormat"%>
<%@ include file="jdbc.jsp"%>
<%@ include file="header.jsp"%>
<%
	boolean insertedPayment = false;
	session = request.getSession(true);

	try {
		insertedPayment = insertPayment(out, request, session);
	} catch (IOException e) {
		System.err.println(e);
	}

	if (insertedPayment == true) { //that payment information has been inserted for that user
		response.sendRedirect("order.jsp"); // continue to order
	} else
		response.sendRedirect("customerpayment.jsp"); // Failed to validate payment info - redirect back to payment page with a message
%>


<%!Boolean insertPayment(JspWriter out, HttpServletRequest request, HttpSession session) throws IOException {

		String paymentType = request.getParameter("paymentType");
		String paymentNumber = request.getParameter("paymentNumber");

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String parameter = request.getParameter("paymentExpiryDate");
		Date paymentExpiryDate = null;
		try {
			paymentExpiryDate = sdf.parse(parameter);
		} catch (Exception e) {

		}

		//java.util.Date util_StartDate = sdf.parse(request.getParameter("paymentExpiryDate") );
		java.sql.Date sqlPaymentExpiryDate = new java.sql.Date(paymentExpiryDate.getTime());
		out.print("<p>Date" + sqlPaymentExpiryDate +"</p>");
		//java.util.Date startDate = sdf.parse(request.getParameter("paymentExpiryDate"));

		//Date paymentExpiryDate = request.getParameter("paymentExpiryDate");

		Boolean retBoolean = false;
		String retStr = null;
		String[] requiredFields = new String[] { paymentType, paymentNumber, sqlPaymentExpiryDate.toString()};
		int index = -1;
		String field = "";
		String error = "";
		for (String s : requiredFields) {
			index++;
			if (s == null || s.length() == 0) {
				switch (index) {
				case 0:
					field = "Payment Type is required.";
					break;
				case 1:
					field = " Payment Number is required.";
					break;
				case 2:
					field = "Expiry Date is required.";
					break;
				default:
					field = "Please fill in the required fields.";
				}
				error += field + " Please try again.";
				session.setAttribute("createUserMessage", error);
				retBoolean = false;
				return retBoolean;
			}
		}

		try {
			getConnection();
			// Check if userId matches some customer account. If so, set retStr to be the username.
			//String custId = request.getParameter("customerId");
			Integer custId = (Integer) session.getAttribute("authenticatedId");
			String insertIntoPayment = "INSERT INTO paymentmethod(paymentType, paymentNumber, paymentExpiryDate, customerId) VALUES (?, ?, ?, ?);";
			PreparedStatement pstmInsert = con.prepareStatement(insertIntoPayment);
			pstmInsert.setString(1, paymentType);
			pstmInsert.setString(2, paymentNumber);
			pstmInsert.setDate(3, sqlPaymentExpiryDate);
			pstmInsert.setInt(4, custId);
			int numRowInserted = pstmInsert.executeUpdate();
			retBoolean = true;
			// }

		} catch (SQLException ex) {
			out.println(ex);
		} finally {
			closeConnection();
		}

		if (retBoolean != true) //i.e username not in database
		{
			session.setAttribute("createUserMessage", "Could not process payment with given payment information");
		} else {
			session.removeAttribute("createUserMessage");
			session.setAttribute("insertedPayment", retBoolean);
		}
		return retBoolean;
	}%>