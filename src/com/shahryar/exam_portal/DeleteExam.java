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

@WebServlet("/deleteExam")
public class DeleteExam extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public DeleteExam() {
        super();
    }


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
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
		
		try {
			
			conn = DriverManager.getConnection(Environment.connectionString, Environment.DBusername, Environment.DBpassword);
			pstmt = conn.prepareStatement("delete from exams where examID=?");
			pstmt.setString(1, examID);
			
			int p = pstmt.executeUpdate();
			
			pstmt = conn.prepareStatement("delete from questions where examID=?");
			pstmt.setString(1, examID);
			
			int p2 = pstmt.executeUpdate();
			
			res.put("success", true);
			out.print(res);
		}
		catch (SQLException e) {
			e.printStackTrace();
			response.sendError(500);
		}
	}

}
