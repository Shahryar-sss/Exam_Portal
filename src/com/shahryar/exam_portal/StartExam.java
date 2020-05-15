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

@WebServlet("/startExam")
public class StartExam extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
    public StartExam() {
        super();
    }
    
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String sreq = request.getParameter("startData");
		JSONObject req = new JSONObject(sreq);
		
		PrintWriter out = response.getWriter();
		
		String studentEmail = req.getString("studentEmail");
		String examID = req.getString("examID");
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
		}
		catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		
		java.sql.Connection conn = null;
		java.sql.PreparedStatement ps1 = null;
		ResultSet rs1 = null;
		
		try {
			conn = DriverManager.getConnection(Environment.connectionString, Environment.DBusername, Environment.DBpassword);
			
			ps1 = conn.prepareStatement("insert into test_taken (examID, studentEmail) values (?, ?)");
			ps1.setString(1, examID);
			ps1.setString(2, studentEmail);
			
			int p = ps1.executeUpdate();
			
			JSONObject res = new JSONObject();
			res.put("success", true);

			out.print(res);
		}
		catch (SQLException e) {
			e.printStackTrace();
			response.sendError(500);
		}
 	}

}
