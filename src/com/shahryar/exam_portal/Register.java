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

import org.json.JSONException;
import org.json.JSONObject;

@WebServlet("/register")
public class Register extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public Register() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		PrintWriter out = response.getWriter();
		String regData = request.getParameter("regData");
		JSONObject res = new JSONObject();
		
		try {
			JSONObject reg = new JSONObject(regData);
			
			String username = reg.getString("username");
			String email = reg.getString("email");
			String password = reg.getString("password");
			
			try {
				Class.forName("com.mysql.jdbc.Driver");
			}
			catch (ClassNotFoundException e) {
				e.printStackTrace();
			}
			
			java.sql.Connection conn = null;
			java.sql.PreparedStatement pstmt = null, checkPresent = null;
			ResultSet rs = null;
			int insertSuccess;
			
			try {
				conn = DriverManager.getConnection(Environment.connectionString, Environment.DBusername, Environment.DBpassword);
				
				pstmt = conn.prepareStatement("insert into students (email, password, username) values (?, ?, ?)");
				pstmt.setString(1, email);
				pstmt.setString(2, password);
				pstmt.setString(3, username);
				
				checkPresent = conn.prepareStatement("select * from students where email=?");
				checkPresent.setString(1, email);
				rs = checkPresent.executeQuery();
				
				if (rs.next() ==  false) {
					insertSuccess = pstmt.executeUpdate();
					
					res.put("success", true);
					out.println(res);
				}
				else {
					response.sendError(400);
				}
				
				
				
			}
			catch (SQLException e) {
				e.printStackTrace();
				response.sendError(500);
			}
		}
		catch(JSONException e) {
			e.printStackTrace();
		}
	}

}
