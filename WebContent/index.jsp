<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Exam Portal</title>

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
        <link rel="stylesheet" href="./assets/css/index.css" />

        <script>
            function handleFormSubmission() {

                const email = document.getElementById('email').value;
                const pwd = document.getElementById('password').value;

                if (!(/^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$/.test(email)) || (pwd.length === 0)) {

                    const errorMsg = document.getElementById('form_validation_error');
                    errorMsg.style.display = "";

                    setTimeout(() => {
                        errorMsg.style.display = "none";
                    }, 5000);

                }
                else {

                    let loginData = JSON.stringify({
                        "email": email,
                        "password": pwd
                    });

                    $.ajax({
                        type: "POST",
                        url: "studentLogin",
                        data: { "loginData" : loginData },
                        cache: false,
                        async: false,
                        dataType: 'json',
                        success: function(response, status, jqXHR) {
                            sessionStorage.setItem('student_username', response.student_username);
                            sessionStorage.setItem('student_email', email);
                            window.location.href = window.location.href.split('/').slice(0,-1).join('/') + '/student-home.jsp';

                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            
                            if (jqXHR.status == 400) {
                                document.getElementById('ajax_error_text').innerHTML = `<strong>Error ! </strong>Invalid email ID or password.`;

                            }
                            else if (jqXHR.status == 500) {
                                document.getElementById('ajax_error_text').innerHTML = `<strong>Error ! </strong>Could not connect to database. Please check your connection and try again.`;
                            }

                            document.getElementById('ajax_error_alert').style.display = "";
                            
                            setTimeout(() => {
                                document.getElementById('ajax_error_alert').style.display = "none";
                            }, 5000);

                        }

                    });
                }
            }
        </script>

</head>
<body>

    <div class="container" style="display: none;" id="form_validation_error">
        <div class="alert alert-danger alert-dismissible fade show">
            <strong>Error ! </strong>Please enter a valid email address and password
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
    </div>

    <div class="container" style="display: none;" id="ajax_error_alert">
        <div class="alert alert-danger alert-dismissible fade show" id="ajax_error_text">
            <strong>Error ! </strong>Invalid email ID or password.
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
    </div>
    
    <div class="d-flex flex-row align-items-center justify-content-center">
        
        
        <div class="p-2">
            <img src="./assets/img/student-login-big-image.jpg" style="max-height: 100vh;" alt="" class="img-fluid">
        </div>

        <div class="p-2" style=" width: 350px; margin-right: 50px;">

            <div>
                <p class="outer-text">Welcome to</p>
                <p class="inner-text" style="margin-top: -15px;">Shahryar's</p>
                <p class="outer-text" style="margin-top: -15px;">Exam Portal</p>
            </div>

            <br>

            <form autocomplete="off">

                <div class="form-group was-validated" id="email_group">
                    <label for="email">Email</label>
                    <div class="input-group mb-2">
                        <div class="input-group-prepend">
                            <div class="input-group-text">
                                <span style="color: mediumslateblue;">
                                    <i class="fas fa-envelope"></i>
                                </span>
                            </div>
                        </div>
                        <input type="email" pattern="^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$" class="form-control" name="email" id="email"  required>
                    </div>
                </div>

                <div class="form-group was-validated" id="password_group">
                    <label for="password">Password</label>
                    <div class="input-group mb-2">
                        <div class="input-group-prepend">
                            <div class="input-group-text">
                                <span style="color: mediumslateblue;">
                                    <i class="fas fa-key"></i>
                                </span>
                            </div>
                        </div>
                        <input type="password" class="form-control" name="password" id="password" required>
                    </div>
                </div>

                <button type="button" onclick="handleFormSubmission()" id="formSubmitBtn" class="btn btn-warning">Login</button>

            </form>

            <br>
            <br>
            <br>

            <p class="text-muted"> Not yet registered? <a href="register.jsp">Click Here</a></p>
            <p class="text-muted"> Login as <a href="admin-login.jsp">Admin</a> instead</p>          
        </div>
    </div>

</body>
</html>