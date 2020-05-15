<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student | Home</title>

    <script
            src="https://code.jquery.com/jquery-3.5.1.js"
            integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc="
            crossorigin="anonymous">
        </script>
        <script
            src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"
            integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo"
            crossorigin="anonymous"
        ></script>
        <script
            src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"
            integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6"
            crossorigin="anonymous"
        ></script>
        <link
            rel="stylesheet"
            href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
            integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh"
            crossorigin="anonymous"
        />
        <script
            src="https://kit.fontawesome.com/0066f58ef4.js"
            crossorigin="anonymous"
        ></script>
        <link rel="stylesheet" href="./assets/css/student-home.css" />

        <script>
            function setpage() {
                
                if((!sessionStorage.getItem('student_username')) || (!sessionStorage.getItem('student_email'))) {
                    window.location.href = window.location.href.split('/').slice(0,-1).join('/')+'/index.jsp';
                }
                else {
                    document.getElementById("welcome_text").innerHTML = "Hello " + sessionStorage.getItem('student_username');
                    loadExamData();
                }
            }

            function loadExamData() {

                $.ajax({
                    type: "POST",
                    url: "getActiveExams",
                    data: {"email" : sessionStorage.getItem('student_email')},
                    cache: false,
                    async: false,
                    dataType: 'json',
                    success: function(response, status, jqXHR) {
                        
                        if (response.noContent == true) {

                            let noExamHtml = `<div class="text-center" id="noActiveExam">
                                                <img src="./assets/img/no-active-exam.jpg" alt="" style="max-width: 580px; margin-top: -2rem;">
                                                <p class="text-muted">Hurray ! There are no active exams right now.</p>
                                                <p class="text-muted">Check back later !</p>
                                            </div>`;
                            
                            document.getElementById("active_exams_pane").innerHTML = noExamHtml;

                        }

                        else {

                            let colors = ['dark', 'info', 'warning'];

                            let cardHtml = `<div class="row mx-auto" style="margin-bottom: 1rem;">`;

                            for (let i=0; i<response.length; i++) {

                                if ((i%3 == 0) && (i>0)) {

                                    cardHtml += `</div>
                                                <div class="row mx-auto" style="margin-bottom: 1rem;">`;
                                    
                                    let last = colors[2];
                                    colors[2] = colors[1]
                                    colors[1] = colors[0];
                                    colors[0] = last;

                                }

                                cardHtml += `<div class="col-sm-4">
                                                <div class="card border-` + colors[i%3] + ` mb-3" style="max-width: 18rem; height: 100%">
                                                    <div class="card-header text-muted">Published: ` + response[i].publishDate + `</div>
                                                    <div class="card-body text-` + colors[i%3] + `">
                                                        <h5 class="card-title">` + response[i].subject + `</h5>
                                                    </div>
                                                    <ul class="list-group list-group-flush text-` + colors[i%3] + `">
                                                        <li class="list-group-item">Total Questions: ` + response[i].totalQuestions + `</li>
                                                        <li class="list-group-item">Time Allotted: ` + response[i].timeAllotted + ` mins</li>
                                                    </ul>
                                                    <div class="card-body">
                                                        <button type="button" class="btn btn-` + colors[i%3] + `" onclick="start_test('` + response[i].examID + `')">Start Test</button>
                                                    </div>
                                                </div>
                                            </div>`;
                            }

                            cardHtml += `</div>`;

                            document.getElementById('active_exams_pane').innerHTML = cardHtml;



                        }
                    },
                    error: function (jqXHR, textStatus, errorThrown) {
                        console.log(jqXHR);
                    }

                });

                $.ajax({
                    type: "POST",
                    url: "getPastExams",
                    data: {"email" : sessionStorage.getItem('student_email')},
                    cache: false,
                    async: false,
                    dataType: 'json',
                    success: function(response, status, jqXHR) {
                        
                        if (response.noContent == true) {

                            let noExamHtml = `<div class="text-center" id="noPastExam">
                                                <img src="./assets/img/no-past-exam.png" alt="" style="max-width: 540px;">
                                                <p class="text-muted">You have not appeared for any exams yet.</p>
                                                <p class="text-muted">Select an exam from the Active Exams pane to get started</p>
                                            </div>`;
                            
                            document.getElementById("past_exams_pane").innerHTML = noExamHtml;

                        }

                        else {

                            let colors = ['dark', 'info', 'warning'];

                            let cardHtml = `<div class="row mx-auto" style="margin-bottom: 1rem;">`;

                            for (let i=0; i<response.length; i++) {

                                if ((i%3 == 0) && (i>0)) {

                                    cardHtml += `</div>
                                                <div class="row mx-auto" style="margin-bottom: 1rem;">`;
                                    
                                    let last = colors[2];
                                    colors[2] = colors[1]
                                    colors[1] = colors[0];
                                    colors[0] = last;

                                }

                                cardHtml += `<div class="col-sm-4">
                                                <div class="card border-` + colors[i%3] + ` mb-3" style="max-width: 18rem;  height: 100%">
                                                    <div class="card-header text-muted">Published: ` + response[i].publishDate + `</div>
                                                    <div class="card-body text-` + colors[i%3] + `">
                                                        <h5 class="card-title">` + response[i].subject + `</h5>
                                                        <ul>
                                                            <li>Correct: ` + response[i].correct + `</li>
                                                            <li>Wrong: ` + response[i].incorrect + `</li>
                                                            <li>Attempted: ` + response[i].attempted + `</li>
                                                        </ul>
                                                    </div>
                                                    <ul class="list-group list-group-flush text-` + colors[i%3] + `">
                                                        <li class="list-group-item">Total Questions: ` + response[i].totalQuestions + `</li>
                                                        <li class="list-group-item">Time Allotted: ` + response[i].timeAllotted + ` mins</li>
                                                    </ul>
                                                    <div class="card-body">
                                                        <button type="button" class="btn btn-` + colors[i%3] + `" onclick="view_answers('` + response[i].examID + `', '` + response[i].subject + `')" data-toggle="modal" data-target="#view_exam_modal">View Paper</button>
                                                        <button type="button" class="btn btn-` + colors[i%3] + `" onclick="your_answers('` + response[i].examID +`', '` + response[i].subject + `')" data-toggle="modal" data-target="#your_answers_modal">Your Answers</button>
                                                    </div>
                                                </div>
                                            </div>`;
                            }

                            cardHtml += `</div>`;

                            document.getElementById('past_exams_pane').innerHTML = cardHtml;


                        }
                    },
                    error: function (jqXHR, textStatus, errorThrown) {
                        console.log(jqXHR);
                    }

                });

                $.ajax({
                    type: "POST",
                    url: "getUpcomingExams",
                    data: {"email" : sessionStorage.getItem('student_email')},
                    cache: false,
                    async: false,
                    dataType: 'json',
                    success: function(response, status, jqXHR) {
                        
                        if (response.noContent == true) {

                            let noExamHtml = `<div class="text-center" id="noPastExam">
                                                <img src="./assets/img/no-upcoming-exam.jpg" alt="" style="max-width: 540px;">
                                                <p class="text-muted">Yaay! There are no upcoming exams</p>
                                                <p class="text-muted">Take this time to relax, play, and maybe learn some new skills !</p>
                                            </div>`;
                            
                            document.getElementById("upcoming_exams_pane").innerHTML = noExamHtml;

                        }

                        else {

                            let colors = ['dark', 'info', 'warning'];

                            let cardHtml = `<div class="row mx-auto" style="margin-bottom: 1rem;">`;

                            for (let i=0; i<response.length; i++) {

                                if ((i%3 == 0) && (i>0)) {

                                    cardHtml += `</div>
                                                <div class="row mx-auto" style="margin-bottom: 1rem;">`;
                                    
                                    let last = colors[2];
                                    colors[2] = colors[1]
                                    colors[1] = colors[0];
                                    colors[0] = last;

                                }

                                cardHtml += `<div class="col-sm-4">
                                                <div class="card border-` + colors[i%3] + ` mb-3" style="max-width: 18rem;  height: 100%">
                                                    <div class="card-header text-muted">To Be Published: ` + response[i].publishDate + `</div>
                                                    <div class="card-body text-` + colors[i%3] + `">
                                                        <h5 class="card-title">` + response[i].subject + `</h5>
                                                    </div>
                                                    <ul class="list-group list-group-flush text-` + colors[i%3] + `">
                                                        <li class="list-group-item">Total Questions: ` + response[i].totalQuestions + `</li>
                                                        <li class="list-group-item">Time Allotted: ` + response[i].timeAllotted + ` mins</li>
                                                    </ul>
                                                </div>
                                            </div>`;
                            }

                            cardHtml += `</div>`;

                            document.getElementById('upcoming_exams_pane').innerHTML = cardHtml;


                        }
                    },
                    error: function (jqXHR, textStatus, errorThrown) {
                        console.log(jqXHR);
                    }

                });
            } 

            function logout() {
                sessionStorage.clear();
                window.location.href = window.location.href.split('/').slice(0,-1).join('/')+"/index.jsp";
            }

            function start_test(examID) {
                const email = sessionStorage.getItem('student_email');

                let startData = JSON.stringify({
                    "studentEmail": email,
                    "examID": examID
                })

                $.ajax({
                    type:"POST",
                    url: "startExam",
                    data: { "startData" : startData },
                    dataType: "json",
                    cache: false,
                    async: false,
                    success: function (response, textStatus, jqXHR) {
                        loadExamQuestions(examID);
                    },
                    error: function(jqXHR, textStatus, errorThrown) {
                        console.log(jqXHR);
                    }
                })
            }

            function loadExamQuestions(examID) {
                $.ajax({
                    type:"GET",
                    url: "getQuestions",
                    data: { "examID" : examID },
                    dataType: "json",
                    cache: false,
                    async: false,
                    success: function (response, textStatus, jqXHR) {
                        sessionStorage.setItem('examID', examID);
                        sessionStorage.setItem('exam_data', JSON.stringify(response));
                        window.location.href = window.location.href.split('/').slice(0,-1).join('/')+"/exam-page.jsp";
                    },
                    error: function(jqXHR, textStatus, errorThrown) {
                        console.log(jqXHR);
                    }
                })
            }

            function view_answers(examID, subject) {

                $.ajax({
                    type: "GET",
                    url: "getQuestions",
                    data: {"examID" : examID},
                    cache: false,
                    async: false,
                    dataType: 'json',
                    success: function(response, status, jqXHR) {

                        document.getElementById("subject_name").innerHTML = subject;

                        let exam_data = "";
                        for (let i=0; i<response.length; i++) {

                            exam_data +=    `<p>` + response[i].question + `</p>
                                            <ul>
                                                <li>` + response[i].optA + `</li>
                                                <li>` + response[i].optB + `</li>
                                                <li>` + response[i].optC + `</li>
                                                <li>` + response[i].optD + `</li>
                                            </ul>
                                            <p>Answer : ` + response[i].correct + `</p>
                                            <hr>`
                        }

                        document.getElementById("exam_data").innerHTML = exam_data;
                        document.getElementById("view_exam_error").style.display = "none";
                        
                    },
                    error: function (jqXHR, textStatus, errorThrown) {

                        document.getElementById("view_exam_error").style.display = "";
                    }

                });
            }

            function your_answers(examID, subject) {

                document.getElementById("answers_subject").innerHTML = subject;

                let answersData = JSON.stringify({
                    "examID": examID,
                    "studentEmail": sessionStorage.getItem('student_email')
                });

                $.ajax({
                    type: "POST",
                    url: "getAnswersData",
                    data: {"answersData" : answersData},
                    dataType: "json",
                    cache: false,
                    async: false,
                    success: function (response, textStatus, jqXHR) {

                        let answersHtml = "";

                        for (let i=0; i<response.length; i++) {

                            answersHtml += `<p>` + response[i].question + `</p>
                                            <p>Option chosen: ` + response[i].answer + `</p><hr>`;

                        }

                        document.getElementById("answers_data").innerHTML = answersHtml;

                    },
                    error: function (jqXHR, textStatus, errorThrown) {
                        console.log(jqXHR);
                    }
                })

            }
        </script>

</head>

<body onload="setpage()">
    
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a href="" class="navbar-brand">Shahryar's Exam Portal</a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav mr-auto">
                </ul>
                <button class="btn btn-outline-light" onclick="logout()">Logout</button>
            </div>
        </div>
    </nav>

    <div class="container" style="margin-top: 3rem;">
        <p class="float-left inner-text" id="welcome_text"></p>
    </div>

    <br><br>

    <div class="container" style="margin-top: 3rem;">
        <ul class="nav nav-tabs" role="tablist">
            <li class="nav-item">
                <a href="#active_exams_pane" class="nav-link active" role="tab" data-toggle="tab">Active Exams</a>
            </li>
            <li class="nav-item">
                <a href="#upcoming_exams_pane" class="nav-link" role="tab" data-toggle="tab">Upcoming Exams</a>
            </li>
            <li class="nav-item">
                <a href="#past_exams_pane" class="nav-link" role="tab" data-toggle="tab">Previous Exams</a>
            </li>
        </ul>

        <div class="tab-content">

            <div class="tab-pane fade show active" id="active_exams_pane" role="tabpanel" style="margin-top: 2rem;">
                
            </div>

            <div class="tab-pane fade" id="upcoming_exams_pane" role="tabpanel" style="margin-top: 2rem;">
                
            </div>

            <div class="tab-pane fade" id="past_exams_pane" role="tabpanel" style="margin-top: 2rem;">

            </div>

        </div>
    </div>

    <div class="modal fade" tabindex="-1" role="dialog" id="view_exam_modal">
        <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 id="subject_name"></h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body" id="exam_data">
                    <div style="display: none;" id="view_exam_error">
                        <div class="alert alert-danger alert-dismissible fade show">
                            <strong>Error ! </strong>Exam questions could not be retrieved. Please check your connection to the database.
                        </div>
                    </div>
                    
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" tabindex="-1" role="dialog" id="your_answers_modal">
        <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 id="answers_subject"></h5>
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body" id="answers_data">
                    
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

</body>
</html>