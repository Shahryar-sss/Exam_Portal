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
import java.util.UUID;

@WebServlet("/saveExam")
public class SaveExam extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public SaveExam() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		PrintWriter out = response.getWriter();
		JSONObject res = new JSONObject();
		
		String examData = request.getParameter("exam");
		JSONObject exam = new JSONObject(examData); 
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
		}
		catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		
		UUID uuid = UUID.randomUUID();
		String examID = uuid.toString();
		
		String subject = exam.getString("subject");
		String totalQuestions = exam.getString("totalQuestions");
		String timeAllotted = exam.getString("timeAllotted");
		String publishDate = exam.getString("publishDate");
		
		JSONArray questions = exam.getJSONArray("questionList");
		
		java.sql.Connection conn = null;
		java.sql.PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			
			conn = DriverManager.getConnection(Environment.connectionString, Environment.DBusername, Environment.DBpassword);
			
			pstmt = conn.prepareStatement("insert into exams (examID, subject, totalQuestions, timeAllotted, publishDate) values (?,?,?,?,?)");
			
			pstmt.setString(1, examID);
			pstmt.setString(2, subject);
			pstmt.setString(3, totalQuestions);
			pstmt.setString(4, timeAllotted);
			pstmt.setString(5, publishDate);
			
			int p = pstmt.executeUpdate();
			
			for (int i=0; i<questions.length(); i++) {
				
				String question = questions.getJSONObject(i).getString("question");
				String optA = questions.getJSONObject(i).getString("optA");
				String optB = questions.getJSONObject(i).getString("optB");
				String optC = questions.getJSONObject(i).getString("optC");
				String optD = questions.getJSONObject(i).getString("optD");
				String correct = questions.getJSONObject(i).getString("correct");
				
				pstmt = conn.prepareStatement("insert into questions (examID, question, optA, optB, optC, optD, correct) values (?,?,?,?,?,?,?)");
				
				pstmt.setString(1, examID);
				pstmt.setString(2, question);
				pstmt.setString(3, optA);
				pstmt.setString(4, optB);
				pstmt.setString(5, optC);
				pstmt.setString(6, optD);
				pstmt.setString(7, correct);
				
				int p2 = pstmt.executeUpdate();
			}
			
			res.put("success", true);
			out.print(res);
			
		}
		catch (SQLException e) {
			e.printStackTrace();
			response.sendError(500);
		}
	}

}
