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

@WebServlet("/getAnswersData")
public class DisplaySavedAnswers extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public DisplaySavedAnswers() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		PrintWriter out = response.getWriter();
		String answersData = request.getParameter("answersData");
		
		JSONObject req = new JSONObject(answersData);
		JSONArray res = new JSONArray();
		
		String studentEmail = req.getString("studentEmail");
		String examID = req.getString("examID");
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
		}
		
		catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		
		java.sql.Connection conn=  null;
		java.sql.PreparedStatement ps1 = null;
		ResultSet rs = null;
		
		try {
			conn = DriverManager.getConnection(Environment.connectionString, Environment.DBusername, Environment.DBpassword);
			ps1 = conn.prepareStatement("select * from student_answers where examID=? and studentEmail=?");
			ps1.setString(1, examID);
			ps1.setString(2, studentEmail);
			
			rs = ps1.executeQuery();
			
			while (rs.next()) {
				JSONObject j = new JSONObject();
				j.put("question", rs.getString("question"));
				j.put("answer", rs.getString("answer"));
				
				res.put(j);
			}
			
			out.print(res);
		}
		catch (SQLException e) {
			e.printStackTrace();
			response.sendError(500);
		}
	
	}

}
