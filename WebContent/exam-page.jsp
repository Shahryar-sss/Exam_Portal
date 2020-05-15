<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student | Exam</title>

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

        <script>

            if (sessionStorage.getItem(sessionStorage.getItem('examID')) == "submitted"){
                returnHome();
            }

            const exam_data = JSON.parse(sessionStorage.getItem('exam_data'));
            let student_answers = [];
            let activeQ = 0, correct = 0, incorrect = 0, attempted = 0;

            for (let i=0; i<exam_data.length; i++) {
                student_answers.push({
                    "question": exam_data[i].question,
                    "answer" : "Not Attempted"
                })
            }

            function setPage() {

                loadExamData();
                setTimer();
                setQuestionNavPanel();
                showQuestion();
                
            }

            function loadExamData() {

                $.ajax({
                    type:"POST",
                    url: 'getExamDetails',
                    data: {"examID" : sessionStorage.getItem('examID')},
                    dataType: "json",
                    cache: false,
                    async: false,
                    success: function(response, textStatus, jqXHR){
                        sessionStorage.setItem('timeAllotted', response.timeAllotted);
                        sessionStorage.setItem('totalQuestions', response.totalQuestions);
                    },
                    error: function(jqXHR, textStatus, errorThrown) {
                        console.log(jqXHR);
                    }
                })
            }

            function setTimer() {

                let timeLeft = parseInt(sessionStorage.getItem('timeAllotted'))*60;

                let timer = setInterval(() => {
                    
                    if (parseInt(sessionStorage.getItem('timeAllotted')) > 60) {

                        let temp =0;

                        let hour = parseInt(timeLeft / 3600);
                        temp = parseInt(timeLeft % 3600);
                        let min = parseInt(temp / 60);
                        let sec = parseInt(temp % 60);

                        document.getElementById("countdown_timer").innerHTML = hour+"h "+min+"m "+sec+"s";
                        timeLeft--;
                    }
                    else {

                        let min = parseInt(timeLeft / 60);
                        let sec = timeLeft % 60;

                        document.getElementById("countdown_timer").innerHTML = min+"m "+sec+"s";
                        timeLeft--;
                    }

                if ((timeLeft+1)==0)  {
                    clearInterval(timer);
                    submitExam();
                }

                }, 1000);


            }

            function setQuestionNavPanel() {

                let btnHtml = "";

                for (let i=0; i<exam_data.length; i++) {

                    if (i>0 && i%4==0)
                        btnHtml += `<br>`;
                    
                    btnHtml += `<button type="button" class="btn btn-outline-info btn-md m-1" id="q-` + (i+1) + `" onclick="setActiveQ(` + i + `)">` + (i+1) + `</button>`;

                }

                document.getElementById("btnList").innerHTML = btnHtml;
            }

            function showQuestion() {

                let questionHtml = "";

                questionHtml += "Q" + (activeQ+1) +". " + exam_data[activeQ].question;
                document.getElementById('card_header').innerHTML = questionHtml;
                questionHtml = "";

                if (student_answers[activeQ].answer == "Not Attempted") {
                    questionHtml += `<div class="custom-control custom-radio">
                                        <input type="radio" name="option" id="A-` + (activeQ+1) + `" class="custom-control-input" value="A">
                                        <label for="A-` + (activeQ+1) + `" class="custom-control-label">` + exam_data[activeQ].optA + `</label>
                                    </div>
                                    <div class="custom-control custom-radio" style="margin-top: 1rem;">
                                        <input type="radio" name="option" id="B-` + (activeQ+1) + `" class="custom-control-input" value="B">
                                        <label for="B-` + (activeQ+1) + `" class="custom-control-label">` + exam_data[activeQ].optB + `</label>
                                    </div>
                                    <div class="custom-control custom-radio" style="margin-top: 1rem;">
                                        <input type="radio" name="option" id="C-` + (activeQ+1) + `" class="custom-control-input" value="C">
                                        <label for="C-` + (activeQ+1) + `" class="custom-control-label">` + exam_data[activeQ].optC + `</label>
                                    </div>
                                    <div class="custom-control custom-radio" style="margin-top: 1rem;">
                                        <input type="radio" name="option" id="D-` + (activeQ+1) + `" class="custom-control-input" value="D">
                                        <label for="D-` + (activeQ+1) + `" class="custom-control-label">` + exam_data[activeQ].optD + `</label>
                                    </div>`;
                }

                else {
                    if (student_answers[activeQ].answer == "A"){
                        questionHtml += `<div class="custom-control custom-radio">
                                            <input type="radio" name="option" id="A-` + (activeQ+1) + `" class="custom-control-input" value="A" checked>
                                            <label for="A-` + (activeQ+1) + `" class="custom-control-label">` + exam_data[activeQ].optA + `</label>
                                        </div>
                                        <div class="custom-control custom-radio" style="margin-top: 1rem;">
                                            <input type="radio" name="option" id="B-` + (activeQ+1) + `" class="custom-control-input" value="B">
                                            <label for="B-` + (activeQ+1) + `" class="custom-control-label">` + exam_data[activeQ].optB + `</label>
                                        </div>
                                        <div class="custom-control custom-radio" style="margin-top: 1rem;">
                                            <input type="radio" name="option" id="C-` + (activeQ+1) + `" class="custom-control-input" value="C">
                                            <label for="C-` + (activeQ+1) + `" class="custom-control-label">` + exam_data[activeQ].optC + `</label>
                                        </div>
                                        <div class="custom-control custom-radio" style="margin-top: 1rem;">
                                            <input type="radio" name="option" id="D-` + (activeQ+1) + `" class="custom-control-input" value="D">
                                            <label for="D-` + (activeQ+1) + `" class="custom-control-label">` + exam_data[activeQ].optD + `</label>
                                        </div>`;
                    }
                    else if (student_answers[activeQ].answer == "B") {
                        questionHtml += `<div class="custom-control custom-radio">
                                            <input type="radio" name="option" id="A-` + (activeQ+1) + `" class="custom-control-input" value="A">
                                            <label for="A-` + (activeQ+1) + `" class="custom-control-label">` + exam_data[activeQ].optA + `</label>
                                        </div>
                                        <div class="custom-control custom-radio" style="margin-top: 1rem;">
                                            <input type="radio" name="option" id="B-` + (activeQ+1) + `" class="custom-control-input" value="B" checked>
                                            <label for="B-` + (activeQ+1) + `" class="custom-control-label">` + exam_data[activeQ].optB + `</label>
                                        </div>
                                        <div class="custom-control custom-radio" style="margin-top: 1rem;">
                                            <input type="radio" name="option" id="C-` + (activeQ+1) + `" class="custom-control-input" value="C">
                                            <label for="C-` + (activeQ+1) + `" class="custom-control-label">` + exam_data[activeQ].optC + `</label>
                                        </div>
                                        <div class="custom-control custom-radio" style="margin-top: 1rem;">
                                            <input type="radio" name="option" id="D-` + (activeQ+1) + `" class="custom-control-input" value="D">
                                            <label for="D-` + (activeQ+1) + `" class="custom-control-label">` + exam_data[activeQ].optD + `</label>
                                        </div>`
                    }
                    else if (student_answers[activeQ].answer == "C") {
                        questionHtml += `<div class="custom-control custom-radio">
                                            <input type="radio" name="option" id="A-` + (activeQ+1) + `" class="custom-control-input" value="A">
                                            <label for="A-` + (activeQ+1) + `" class="custom-control-label">` + exam_data[activeQ].optA + `</label>
                                        </div>
                                        <div class="custom-control custom-radio" style="margin-top: 1rem;">
                                            <input type="radio" name="option" id="B-` + (activeQ+1) + `" class="custom-control-input" value="B">
                                            <label for="B-` + (activeQ+1) + `" class="custom-control-label">` + exam_data[activeQ].optB + `</label>
                                        </div>
                                        <div class="custom-control custom-radio" style="margin-top: 1rem;">
                                            <input type="radio" name="option" id="C-` + (activeQ+1) + `" class="custom-control-input" value="C" checked>
                                            <label for="C-` + (activeQ+1) + `" class="custom-control-label">` + exam_data[activeQ].optC + `</label>
                                        </div>
                                        <div class="custom-control custom-radio" style="margin-top: 1rem;">
                                            <input type="radio" name="option" id="D-` + (activeQ+1) + `" class="custom-control-input" value="D">
                                            <label for="D-` + (activeQ+1) + `" class="custom-control-label">` + exam_data[activeQ].optD + `</label>
                                        </div>`;
                    }
                    else {
                        questionHtml += `<div class="custom-control custom-radio">
                                            <input type="radio" name="option" id="A-` + (activeQ+1) + `" class="custom-control-input" value="A">
                                            <label for="A-` + (activeQ+1) + `" class="custom-control-label">` + exam_data[activeQ].optA + `</label>
                                        </div>
                                        <div class="custom-control custom-radio" style="margin-top: 1rem;">
                                            <input type="radio" name="option" id="B-` + (activeQ+1) + `" class="custom-control-input" value="B">
                                            <label for="B-` + (activeQ+1) + `" class="custom-control-label">` + exam_data[activeQ].optB + `</label>
                                        </div>
                                        <div class="custom-control custom-radio" style="margin-top: 1rem;">
                                            <input type="radio" name="option" id="C-` + (activeQ+1) + `" class="custom-control-input" value="C">
                                            <label for="C-` + (activeQ+1) + `" class="custom-control-label">` + exam_data[activeQ].optC + `</label>
                                        </div>
                                        <div class="custom-control custom-radio" style="margin-top: 1rem;">
                                            <input type="radio" name="option" id="D-` + (activeQ+1) + `" class="custom-control-input" value="D" checked>
                                            <label for="D-` + (activeQ+1) + `" class="custom-control-label">` + exam_data[activeQ].optD + `</label>
                                        </div>`;
                    }
                }


                document.getElementById("card_body").innerHTML = questionHtml;

            }

            function nextQuestion() {
                setActiveQ(activeQ+1);
            }

            function previousQuestion() {
                setActiveQ(activeQ-1)
            }

            function setActiveQ(translate) {
                activeQ = translate;

                if (activeQ > 0) {
                    document.getElementById("previousBtn").style.display = "";
                }
                
                if (activeQ == 0) {
                    document.getElementById("previousBtn").style.display = "none";
                }

                if (activeQ == (sessionStorage.getItem('totalQuestions')-1)) {
                    document.getElementById("nextBtn").style.display = "none";
                }

                if (activeQ !== (sessionStorage.getItem('totalQuestions')-1)) {
                    document.getElementById("nextBtn").style.display = "";
                }

                showQuestion();

            }

            function saveAnswer() {

                let options = document.getElementsByName("option");

                for (let i=0; i<options.length; i++) {

                    if (options[i].checked){

                        attempted++;

                        if (options[i].value == exam_data[activeQ].correct)  
                            correct++;
                        else 
                            incorrect++;


                        student_answers[activeQ].answer = options[i].value;

                        document.getElementById("q-"+(activeQ+1)).classList.remove("btn-outline-info");
                        document.getElementById("q-"+(activeQ+1)).classList.add("btn-success");
                    }
                }
            }

            function submitExam() {

                let saveData = JSON.stringify({
                    "studentEmail": sessionStorage.getItem('student_email'),
                    "examID": sessionStorage.getItem('examID'),
                    "correct": correct,
                    "incorrect": incorrect,
                    "attempted": attempted,
                    "answers": student_answers
                });

                sessionStorage.setItem(sessionStorage.getItem('examID'), "submitted");

                document.getElementById("countdown_timer").style.display = "none";
                document.getElementById("mainContent").style.display = "none"

                cardHtml = `<div class="card border-primary" style="max-width: 18rem;  height: 100%; margin: auto">
                            <div class="card-header">Your Score Card</div>
                            <div class="card-body">
                                <h5 class="card-title">` + sessionStorage.getItem('student_username') + `</h5>
                                <ul>
                                    <li>Correct: ` + correct + `</li>
                                    <li>Wrong: ` + incorrect + `</li>
                                    <li>Attempted: ` + attempted + `</li>
                                </ul>
                            </div>
                            <ul class="list-group list-group-flush">
                                <li class="list-group-item">Total Questions: ` + sessionStorage.getItem('totalQuestions') + `</li>
                                <li class="list-group-item">Time Allotted: ` + sessionStorage.getItem('timeAllotted') + ` mins</li>
                            </ul>
                            <div class="card-body">
                                <button type="button" class="btn btn-primary" onclick="returnHome()" >Return to Dashboard</button>
                            </div>
                        </div>`;

                document.getElementById('scorecard').innerHTML = cardHtml;
                document.getElementById('scorecard').style.display = "";

                $.ajax({
                    type: "POST",
                    url: "saveAnswers",
                    data: { "saveData" : saveData},
                    dataType: "json",
                    cache: false,
                    async: false,
                    success: function(response, textStatus, jqXHR) {

                    },
                    error: function(jqXHR, textStatus, errorThrown) {

                    }
                })

            }

            function returnHome() {

                sessionStorage.removeItem(sessionStorage.getItem('examID'));
                sessionStorage.removeItem('examID');
                sessionStorage.removeItem('exam_data');
                sessionStorage.removeItem('timeAllotted');
                sessionStorage.removeItem('totalQuestions');

                window.location.href = window.location.href.split('/').slice(0,-1).join('/') + "/student-home.jsp";
            }
        </script>

</head>
<body onload="setPage()">

    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a href="" class="navbar-brand">Shahryar's Exam Portal</a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav mr-auto">
                </ul>
                <div class="p-0">
                    <div class="badge badge-pill badge-light" style="font-size: 24px;" id="countdown_timer">
                    </div>
                </div>
            </div>
        </div>
    </nav>

    <div id="mainContent">
        <div class="d-flex flex-row justify-content-center" id="mainContent">
    
            <div class="p-5" style="width: 65%;">
    
                <div class="card">
                    <h5 class="card-header" id="card_header"></h5>
                    <div class="card-body" id="card_body">
                    </div>
                    <div class="card-footer">
                        <button type="button" class="btn btn-primary btn-sm mr-5" onclick="saveAnswer()" id="saveBtn">Save</button>
                        <button type="button" class="btn btn-secondary btn-sm float-right ml-3" onclick="nextQuestion()" id="nextBtn">Next</button>
                        <button type="button" class="btn btn-secondary btn-sm float-right" onclick="previousQuestion()" id="previousBtn" style="display: none;">Previous</button>
                    </div>
                </div>
    
            </div>
    
            <div class="p-5">
                
                <div class="d-flex flex-column text-center">
    
                    <div class="p-0">
                        <div class="card">
                            <div class="card-header">Questions</div>
                            <div class="card-body" style="width: auto;" id="btnList">
                            </div>
                            <div class="card-footer">
                                <button type="button" class="btn btn-outline-danger btn-md" onclick="submitExam()">Submit Test</button>
                            </div>
                        </div>
                    </div>
    
                </div>
    
            </div>
    
        </div>
    </div>

    <div style="display: none; margin: auto; margin-top: 5rem;" id="scorecard">
        
    </div>
    
</body>
</html>