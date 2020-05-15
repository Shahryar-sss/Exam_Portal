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

@WebServlet("/getQuestions")
public class DisplayExamQuestions extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public DisplayExamQuestions() {
        super();
        
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		PrintWriter out = response.getWriter();
		JSONObject res = new JSONObject();
		
		String examID = request.getParameter("examID");
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
		}
		catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		
		java.sql.Connection conn = null;
		java.sql.PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		JSONArray questions = new JSONArray();
		
		try {
			conn = DriverManager.getConnection(Environment.connectionString, Environment.DBusername, Environment.DBpassword);
			pstmt = conn.prepareStatement("select * from questions where examID=?");
			pstmt.setString(1, examID);
			
			rs = pstmt.executeQuery();
			
			while (rs.next()) {
				
				JSONObject j = new JSONObject();
				
				j.put("question", rs.getString("question"));
				j.put("optA", rs.getString("optA"));
				j.put("optB", rs.getString("optB"));
				j.put("optC", rs.getString("optC"));
				j.put("optD", rs.getString("optD"));
				j.put("correct", rs.getString("correct"));
				
				questions.put(j);
			}
			out.print(questions);
		}
		catch (SQLException e) {
			
			e.printStackTrace();
			response.sendError(500);
		}
	}

}
