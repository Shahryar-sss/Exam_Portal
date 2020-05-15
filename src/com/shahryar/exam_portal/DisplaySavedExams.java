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

import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/getSavedExams")
public class DisplaySavedExams extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public DisplaySavedExams() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		PrintWriter out = response.getWriter();
		JSONObject res = new JSONObject();
		
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
			pstmt = conn.prepareStatement("select * from exams");
			rs = pstmt.executeQuery();
			
			if (rs.next() == false) {
				res.put("noContent", true);
				out.print(res);
			}
			else {
				JSONArray examsList = new JSONArray();
				
				do {
					JSONObject singleExam = new JSONObject();
					
					singleExam.put("examID", rs.getString("examID"));
					singleExam.put("subject", rs.getString("subject"));
					singleExam.put("totalQuestions", rs.getString("totalQuestions"));
					singleExam.put("timeAllotted", rs.getString("timeAllotted"));
					singleExam.put("publishDate", rs.getString("publishDate"));
					
					examsList.put(singleExam);
				}
				while (rs.next());
				
				out.print(examsList);
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
			response.sendError(500);
		}
	}

}
