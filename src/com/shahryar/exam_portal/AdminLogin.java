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

import com.mysql.jdbc.Connection;
import com.mysql.jdbc.PreparedStatement;

@WebServlet("/adminLogin")
public class AdminLogin extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public AdminLogin() {
        super();
        
    }
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		PrintWriter out = response.getWriter();
		String loginData = request.getParameter("loginData");
		JSONObject res = new JSONObject();
		
		try {
			JSONObject jsonObj = new JSONObject(loginData);
			
			String email = jsonObj.getString("email");
			String password = jsonObj.getString("password");
			
			try {
				Class.forName("com.mysql.jdbc.Driver");
			}
			catch (ClassNotFoundException e) {
				e.printStackTrace();
			}
			
			java.sql.Connection conn = null;
			java.sql.PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try {
				conn = DriverManager.getConnection(Environment.connectionString, Environment.DBusername, Environment.DBpassword);
				pstmt = conn.prepareStatement("select * from admins where email=? and password=?");
				pstmt.setString(1, email);
				pstmt.setString(2, password);
				rs = pstmt.executeQuery();
				
				if (rs.next()) {
					res.put("username", rs.getString("username"));
					out.print(res);
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
		catch (JSONException e) {
			e.printStackTrace();
		}
	}

}
