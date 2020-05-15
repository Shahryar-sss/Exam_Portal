package com.shahryar.exam_portal;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.DriverManager;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/saveAnswers")
public class SaveAnswers extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public SaveAnswers() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		PrintWriter out = response.getWriter();
		String req_s = request.getParameter("saveData");
		
		JSONObject req = new JSONObject(req_s);
		
		String email = req.getString("studentEmail");
		String examID = req.getString("examID");
		
		JSONArray answers = req.getJSONArray("answers");
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
		}
		catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		
		java.sql.Connection conn = null;
		java.sql.PreparedStatement ps1 = null;
		
		try {
			conn = DriverManager.getConnection(Environment.connectionString, Environment.DBusername, Environment.DBpassword);
			
			for (int i=0; i<answers.length(); i++) {
				ps1 = conn.prepareStatement("insert into student_answers (examID, studentEmail, question, answer) values (?, ?, ?, ?)");
				ps1.setString(1, examID);
				ps1.setString(2, email);
				ps1.setString(3, answers.getJSONObject(i).getString("question"));
				ps1.setString(4, answers.getJSONObject(i).getString("answer"));
				
				int p = ps1.executeUpdate();
			}
			
			String correct = String.valueOf(req.getInt("correct"));
			String incorrect = String.valueOf(req.getInt("incorrect"));
			String attempted = String.valueOf(req.getInt("attempted"));
			
			ps1 = conn.prepareStatement("update test_taken set correct=?, incorrect=?, attempted=? where studentEmail=? and examID=?");
			ps1.setString(1, correct);
			ps1.setString(2, incorrect);
			ps1.setString(3, attempted);
			ps1.setString(4, email);
			ps1.setString(5, examID);
			
			int p2 = ps1.executeUpdate();
			
			JSONObject j = new JSONObject();
			j.put("success", true);
			out.print(j);
		}
		catch (SQLException e) {
			e.printStackTrace();
			response.sendError(500);
		}
	}

}
