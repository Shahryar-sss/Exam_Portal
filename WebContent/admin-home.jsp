<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin | Home</title>

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
        <link rel="stylesheet" href="./assets/css/admin-home.css" />

        <script>

            function validateAndShowDetailsForm() {
                const subject = document.getElementById('subject').value;
                const totalQuestions = document.getElementById('totalQuestions').value;
                const timeAllotted = document.getElementById('timeAllotted').value;
                const publishDate = document.getElementById('publishDate').value;

                const date = new Date(publishDate);

                if ((subject === "")  || (totalQuestions === "")  || (timeAllotted === ""))  {
                    document.getElementById('alert_text').innerHTML = "<strong>Error ! </strong>Please fill the entire form.";
                    document.getElementById('form_validation_error').style.display="";

                    setTimeout(() => {
                        document.getElementById('form_validation_error').style.display="none";
                    }, 5000);

                }

                else if (date == "Invalid Date") {
                    document.getElementById('alert_text').innerHTML = "<strong>Error ! </strong>No date or an invalid date has been selected";

                    document.getElementById('form_validation_error').style.display="";

                    setTimeout(() => {
                        document.getElementById('form_validation_error').style.display="none";
                    }, 5000);
                }

                else {

                    sessionStorage.setItem('subject', subject);
                    sessionStorage.setItem('totalQuestions', totalQuestions);
                    sessionStorage.setItem('timeAllotted', timeAllotted);
                    sessionStorage.setItem('publishDate', publishDate);

                    document.getElementById('addExamForm').style.display = "none";
                    document.getElementById('examDetailsForm').style.display = "";

                    let formHtml = "";
                    for (let i=0; i<totalQuestions; i++) {
                        formHtml += `<div class="form-group">
                                <label for="question` + (i+1) + `">Question ` + (i+1) + `</label>
                                <input type="text" class="form-control" name="question` + (i+1) + `" id="question` + (i+1) + `" required>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="A-` + (i+1) + `">Option A</label>
                                    <input type="text" class="form-control" name="A-` + (i+1) + `" id="A-` + (i+1) + `" required>
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="B-` + (i+1) + `">Option B</label>
                                    <input type="text" class="form-control" name="B-` + (i+1) + `" id="B-` + (i+1) + `" required>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="C-` + (i+1) + `">Option C</label>
                                    <input type="text" class="form-control" name="C-` + (i+1) + `" id="C-` + (i+1) + `" required>
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="D-` + (i+1) + `">Option D</label>
                                    <input type="text" class="form-control" name="D-` + (i+1) + `" id="D-` + (i+1) + `" required>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="input-group mb-3">
                                    <div class="input-group-prepend">
                                        <label for="correct-` + (i+1) + `" class="input-group-text">Choose Correct Option</label>
                                    </div>
                                    <select class="custom-select" name="correct-` + (i+1) + `" id="correct-` + (i+1) + `">
                                        <option value="A">option A</option>
                                        <option value="B">option B</option>
                                        <option value="C">option C</option>
                                        <option value="D">option D</option>
                                    </select>
                                </div>
                            </div>
                            <br>
                            <hr>
                            <br>`
                    }

                    document.getElementById('examDetailsForm').innerHTML = formHtml;
                    document.getElementById('modalSaveBtn').disabled = false;
                }
                 
            }

            function modalClose() {

                document.getElementById("addExamForm").style.display = "";
                document.getElementById("addExamForm").reset();
                document.getElementById("examDetailsForm").style.display = "none";
                document.getElementById("examDetailsForm").reset();
                document.getElementById('modalSaveBtn').disabled = true;
                sessionStorage.removeItem('subject');
                sessionStorage.removeItem('totalQuestions');
                sessionStorage.removeItem('timeAllotted');
                sessionStorage.removeItem('publishDate');
            }

            function modalSave() {

                let totalQuestions = sessionStorage.getItem('totalQuestions');
                let examData = [];
                let flag = 0;

                for (let i=0; i<totalQuestions; i++) {

                    let question = document.getElementById("question" + (i+1)).value;
                    let optA = document.getElementById("A-" + (i+1)).value;
                    let optB = document.getElementById("B-" + (i+1)).value;
                    let optC = document.getElementById("C-" + (i+1)).value;
                    let optD = document.getElementById("D-" + (i+1)).value;
                    let correct = document.getElementById("correct-" + (i+1)).value;

                    if ((question === "") || (optA === "") || (optB === "") || (optC === "") || (optD === "") || (correct === "")) {

                        document.getElementById('alert_text').innerHTML = "<strong>Error ! </strong>Please enter all the details and try again";

                        document.getElementById('form_validation_error').style.display="";

                        setTimeout(() => {
                            document.getElementById('form_validation_error').style.display="none";
                        }, 5000);

                        flag = 1;
                        break;
                    }

                    examData.push({
                        "question": question,
                        "optA": optA,
                        "optB": optB,
                        "optC": optC,
                        "optD": optD,
                        "correct": correct
                    })

                }

                if (flag == 0){

                    const exam = {
                        "subject": sessionStorage.getItem('subject'),
                        "totalQuestions": totalQuestions,
                        "timeAllotted": sessionStorage.getItem('timeAllotted'),
                        "publishDate": sessionStorage.getItem('publishDate'),
                        "questionList": examData
                    }

                    saveExamToDatabase(exam);
                }

            }

            function saveExamToDatabase(exam) {
                
                $.ajax({
                    type: "POST",
                    url: "saveExam",
                    data: {"exam": JSON.stringify(exam)},
                    cache: false,
                    async: false,
                    dataType: 'json',
                    success: function(response, status, jqXHR) {

                        document.getElementById('modalCloseBtn').click();
                        getSavedExams();
                    },
                    error: function (jqXHR, textStatus, errorThrown) {
                        document.getElementById('alert_text').innerHTML = "<strong>Error ! </strong>Database connection error or bad request. Please try again";

                        document.getElementById('form_validation_error').style.display="";

                        setTimeout(() => {
                            document.getElementById('form_validation_error').style.display="none";
                        }, 5000);
                    }

                });

            }

            function getSavedExams() {
                
                $.ajax({
                    type: "GET",
                    url: "getSavedExams",
                    cache: false,
                    async: false,
                    dataType: 'json',
                    success: function(response, status, jqXHR) {

                        if (response.noContent == true){

                            document.getElementById('noExamImage').style.display = "";
                            document.getElementById('exam_table').style.display = "none";

                        }
                        else {
                            document.getElementById('noExamImage').style.display = "none";
                            document.getElementById('exam_table').style.display = "";

                            document.getElementById('modalCloseBtn').click();
    
                            let tableHtml = "";
    
                            for (let i=0; i<response.length; i++) {
                                tableHtml += `<tr>
                                                <td scope="row">` + (i+1) +`</td>
                                                <td>` + response[i].subject + `</td>
                                                <td>` + response[i].totalQuestions + `</td>
                                                <td>` + response[i].timeAllotted + `</td>
                                                <td>` + response[i].publishDate + `</td>
                                                <td><button class="btn btn-success btn-sm" data-toggle="modal" data-target="#view_exam_modal" onclick="viewExam('` + response[i].examID + `', '` + response[i].subject + `')">View</button></td>
                                                <td><button class="btn btn-danger btn-sm" onclick="deleteExam('` + response[i].examID + `')">Delete</button></td>
                                            </tr>`
                            }
                            
                            document.getElementById('savedExamsList').innerHTML = tableHtml;
                        }
                    },
                    error: function (jqXHR, textStatus, errorThrown) {

                        document.getElementById('alert_text_error').innerHTML = `<strong>Error ! </strong>Exam data could not be fetched. Please check your connection to the database`;
                        document.getElementById('exam_delete_error').style.display = "";

                    }


                });
            }

            function deleteExam(examID) {

                $.ajax({
                    type: "POST",
                    url: "deleteExam",
                    data: {"examID" : examID},
                    cache: false,
                    async: false,
                    dataType: 'json',
                    success: function(response, status, jqXHR) {
                        getSavedExams();

                        document.getElementById('alert_text_success').innerHTML = "<strong>Success ! </strong>The exam has been deleted.";
                        document.getElementById('exam_delete_success').style.display = "";

                        setTimeout(() => {
                            document.getElementById('exam_delete_success').style.display = "none";
                        }, 5000);
                    },
                    error: function (jqXHR, textStatus, errorThrown) {

                        document.getElementById('alert_text_error').innerHTML = "<strong>Error ! </strong>The exam could not be deleted. Please check your connection to the database";
                        document.getElementById('exam_delete_error').style.display = "";

                        setTimeout(() => {
                            document.getElementById('exam_delete_error').style.display = "none";
                        }, 5000);

                    }

                });
                
            }

            function viewExam(examID, subject) {

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

                        document.getElementById('view_exam_error').style.display = "";

                        setTimeout(() => {
                            document.getElementById('exam_delete_error').style.display = "none";
                        }, 5000);

                    }

                });

            }

            function logout () {
                sessionStorage.clear();
                window.location.href = window.location.href.split('/').slice(0, -1).join('/')+"/admin-login.jsp";
            }

            function setPage() {

                if (!sessionStorage.getItem('admin_username')){
                    window.location.href = window.location.href.split('/').slice(0,-1).join('/') + "/admin-login.jsp";
                }
                else {
                    document.getElementById('welcome_text').innerHTML = "Hello " + sessionStorage.getItem('admin_username') + " !";
                    
                    getSavedExams();

                }


            }




        </script>

</head>
<body onload="setPage()">

    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a href="" class="navbar-brand">Shahryar's Exam Portal</a>
            <div class="collpase navbar-collapse">
                <ul class="navbar-nav mr-auto"></ul>
                <button class="btn btn-outline-light" onclick="logout()">Logout</button>
            </div>
        </div>
    </nav>

    <div style="display: none;" id="exam_delete_success">
        <div class="alert alert-success alert-dismissible fade show text-center" id="alert_text_success">
            <strong>Success ! </strong>The exam has been deleted.
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
    </div>

    <div style="display: none;" id="exam_delete_error">
        <div class="alert alert-danger alert-dismissible fade show text-center" id="alert_text_error">
            <strong>Error ! </strong>The exam could not be deleted due to an internal error. Please try again.
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
    </div>

    <div class="container inline" style="margin-top: 3rem;">
        <p class="outer-text float-left" id="welcome_text">Hello </p>
        <button class="btn btn-warning float-right" data-toggle="modal" data-target="#addExamModal" style="color: white;"><i class="fa fa-file-alt mr-2"></i>Add Exam</button>
        <br>
        <br>
        <hr>
    </div>

    <div class="container" id="noExamImage">
        <br>
        <br>
        <div class="text-center">
            <img src="./assets/img/no-exam-image.jpeg" class="img-fluid" style="max-width: 580px;" alt="">
            <p class="text-muted" style="margin-top: 20px;">No exams have been added yet.</p>
            <p class="text-muted">Click on the button above to get started.</p>
        </div>
    </div>

    <div class="container text-center" id="exam_table" style="width: 80%; display: none;">
        <br>
        <br>
        <table class="table table-striped ">
            <thead class="thead-dark">
                <tr>
                    <th scope="col">#</th>
                    <th>Subject</th>
                    <th>Total Questions</th>
                    <th>Time Allotted (mins)</th>
                    <th>Publish Date</th>
                    <th></th>
                    <th></th>
                </tr>
            </thead>
            <tbody id="savedExamsList">
            </tbody>
        </table>
    </div>

    <div class="modal fade" id="addExamModal" data-backdrop="static" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-lg modal-dialog-scrollable" role="document">
            <div class="modal-content">
                <div style="display: none;" id="form_validation_error">
                    <div class="alert alert-danger alert-dismissible fade show" id="alert_text">
                        <strong>Error ! </strong>Please fill the entire form.
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                </div>
                <div class="modal-header">
                    <h5 class="modal-title">Add New Exam</h5>
                    <button type="button" class="close" data-dismiss="modal" onclick="modalClose()" id="modalCloseBtn">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="container-fluid">
                        <form id="addExamForm" class="was-validated">
                            <div class="form-group">
                                <label for="subject">Subject</label>
                                <input type="text" class="form-control" name="subject" id="subject" required>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-4">
                                    <label for="totalQuestions">Total Questions</label>
                                    <input type="number" class="form-control" name="totalQuestions" id="totalQuestions" required>
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="timeAllotted">Time Allotted (in mins)</label>
                                    <input type="number" class="form-control" name="timeAllotted" id="timeAllotted" required>
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="publishDate">Publish Date</label>
                                    <input type="date" class="form-control" name="publishDate" id="publishDate" required>
                                    <small class="text-muted">Select today's date to publish now</small>
                                </div>
                            </div>
                            <button type="button" class="btn btn-primary" onclick="validateAndShowDetailsForm()">Next</button>
                        </form>

                        <form class="was-validated" id="examDetailsForm" style="display: none;">
                            
                        </form>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal" id="modalCloseBtn" onclick="modalClose()">Close</button>
                    <button type="button" class="btn btn-primary" id="modalSaveBtn" onclick="modalSave()" disabled>Save</button>
                </div>
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
    
</body>
</html>