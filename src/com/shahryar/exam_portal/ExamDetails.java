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

@WebServlet("/getExamDetails")
public class ExamDetails extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public ExamDetails() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String examID = request.getParameter("examID");
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
		}
		catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		
		java.sql.Connection conn = null;
		java.sql.PreparedStatement ps1 = null;
		ResultSet rs = null;
		
		try {
			conn = DriverManager.getConnection(Environment.connectionString, Environment.DBusername, Environment.DBpassword);
			ps1 = conn.prepareStatement("select * from exams where examID=?");
			ps1.setString(1, examID);
			
			rs = ps1.executeQuery();
			
			JSONObject j = new JSONObject();
			PrintWriter out = response.getWriter();
			
			rs.next();
			
			j.put("timeAllotted", rs.getString("timeAllotted"));
			j.put("totalQuestions", rs.getString("totalQuestions"));
			
			out.print(j);
		}
		catch (SQLException e) {
			e.printStackTrace();
			response.sendError(500);
		}
	}

}
