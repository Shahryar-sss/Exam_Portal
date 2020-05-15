package com.shahryar.exam_portal;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

@WebServlet("/studentLogin")
public class StudentLogin extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public StudentLogin() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String loginData = request.getParameter("loginData");
		JSONObject data = new JSONObject(loginData);
		
		JSONObject res = new JSONObject();
		PrintWriter out = response.getWriter();
		
		String email = data.getString("email");
		String password = data.getString("password");
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		
		java.sql.Connection conn = null;
		java.sql.PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = DriverManager.getConnection(Environment.connectionString, Environment.DBusername, Environment.DBpassword);
			pstmt = conn.prepareStatement("select * from students where email=?");
			pstmt.setString(1, email);
			
			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				if (rs.getString("password").equalsIgnoreCase(password)) {
					res.put("student_username", rs.getString("username"));
					out.print(res);
					return;
				}
				else {
					response.sendError(400);
					return;
				}
			}
			else {
				response.sendError(400);
				return;
			}
			
		}
		catch (SQLException e) {
			e.printStackTrace();
			response.sendError(500);
		}
	}

}
