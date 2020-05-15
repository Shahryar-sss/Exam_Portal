package com.shahryar.exam_portal;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/getActiveExams")
public class DisplayActiveExams extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public DisplayActiveExams() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		PrintWriter out = response.getWriter();
		JSONObject jo = new JSONObject();
		JSONArray res = new JSONArray();
		
		String email = request.getParameter("email");
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
		}
		catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		
		java.sql.Connection conn = null;
		java.sql.PreparedStatement ps1 = null, ps2 = null;
		ResultSet rs = null, rs2 = null;
		
		String dateFormat = "yyyy-MM-dd";
		SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
		Date today = new Date();
		
		int flag = 0;
		
		
		try {
			
			conn = DriverManager.getConnection(Environment.connectionString, Environment.DBusername, Environment.DBpassword);
			ps1 = conn.prepareStatement("select * from exams");
			
			rs = ps1.executeQuery();
			
			if (rs.next()) {
				
				do {
					String publishDt = rs.getString("publishDate");
					try {
						Date publishDate = sdf.parse(publishDt);
						if (publishDate.compareTo(today) < 0) {
							
							
							ps2 = conn.prepareStatement("select * from test_taken where examID=? and studentEmail=?");
							ps2.setString(1, rs.getString("examID"));
							ps2.setString(2, email);
							
							rs2 = ps2.executeQuery();
							
							if (!rs2.next()) {
								JSONObject jb = new JSONObject();
								
								jb.put("examID", rs.getString("examID"));
								jb.put("subject", rs.getString("subject"));
								jb.put("totalQuestions", rs.getString("totalQuestions"));
								jb.put("timeAllotted", rs.getString("timeAllotted"));
								jb.put("publishDate", rs.getString("publishDate"));
								
								res.put(jb);
								flag ++;
							}
							
						}
					} catch (ParseException e) {
						e.printStackTrace();
					}
				}
				while (rs.next());
				
				if (flag > 0) {
					out.print(res);
					return;
				}
			}
			
			else {
				jo.put("noContent", true);
				out.print(jo);
			}
			
			if (flag == 0) {
				jo.put("noContent", true);
				out.print(jo);
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
			response.sendError(500);
		}
	}

}
