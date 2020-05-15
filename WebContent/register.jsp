<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student | Register</title>

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
        <link rel="stylesheet" href="./assets/css/register.css" />

        <script>
            function enableCPassword() {
                const pwd = document.getElementById('password').value;
                if (pwd.length !== 0) {
                    document.getElementById('c_password').disabled = false;

                    const elem = document.getElementById('c_password');
                    let pat = '^' + pwd.trim() + '$';
                    elem.setAttribute('pattern', pat);

                    checkPwdMatch();
                }
                else{
                    document.getElementById('c_password').disabled = true;
                    document.getElementById('c_password').value = "";
                    document.getElementById('password_error').style.display = "none";
                }
            }

            function checkPwdMatch() {
                const pwd = document.getElementById('password').value;
                const c_pwd = document.getElementById('c_password').value;

                if (c_pwd !== pwd)
                    document.getElementById('password_error').style.display = "";
                else
                    document.getElementById('password_error').style.display = "none";
            }

            function handleFormSubmission() {
                const email = document.getElementById('email');
                const pwd = document.getElementById('password');
                const c_pwd = document.getElementById('c_password');
                const uname = document.getElementById('username');

                if (!(/^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$/.test(email.value))
                    || (pwd.value !== c_pwd.value)
                    || (pwd.value.length === 0)
                    || (c_pwd.value.length === 0)
                    || (uname.value.length === 0)) {

                    const errorMsg = document.getElementById('form_validation_error');       
                    errorMsg.style.display = "";

                    setTimeout(() => {
                        errorMsg.style.display = "none";
                    }, 5000);

                }
                else {
                    let regData = JSON.stringify({
                        "email": email.value,
                        "password": pwd.value,
                        "username": uname.value
                    })

                    $.ajax({
                        type: "POST",
                        url: "register",
                        data: { "regData": regData},
                        cache: false,
                        async: false,
                        dataType: 'json',
                        success: function(response, status, jqXHR) {
                            const successMsg = document.getElementById('acc_creation_success');
                            successMsg.style.display = "";
                            email.disabled = true;
                            pwd.disabled = true;
                            username.disabled = true;
                            c_pwd.disabled = true;
                            
                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            if (jqXHR.status == 400) {
                                document.getElementById('ajax_error_text').innerHTML = `<strong>Error ! </strong>This email address is already associated with an account. Try <a href="index.jsp" class="alert-link">signing in</a>`;

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

    <div class="container" style="display: none;" id="ajax_error_alert">
        <div class="alert alert-danger alert-dismissible fade show" id="ajax_error_text">
            <strong>Error ! </strong>This email address is already associated with an account. Try <a href="index.jsp" class="alert-link">signing in</a>.
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
    </div>

    <div class="container" style="display: none;" id="form_validation_error">
        <div class="alert alert-danger alert-dismissible fade show">
            <strong>Error ! </strong>Please enter your username, a valid email address and matching passwords
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
    </div>

    <div class="container" style="display: none;" id="acc_creation_success">
        <div class="alert alert-success alert-dismissible fade show">
            <strong>Success ! </strong>Your account has been created. <a href="index.jsp" class="alert-link">Click here</a> to sign in.
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
    </div>
    
    <div class="d-flex flex-row align-items-center justify-content-center">
        
        <div class="p-2" style=" width: 400px;  margin-left: 30px; margin-right: 20px;">

            <div>
                <p class="outer-text">Register</p>
                <p class="inner-text" style="margin-top: -15px;">Your</p>
                <p class="outer-text" style="margin-top: -15px;">Account</p>
            </div>

            <br>

            <form autocomplete="off">

                <div class="form-group was-validated" id="username_group">
                    <label for="username">Username</label>
                    <div class="input-group mb-2">
                        <div class="input-group-prepend">
                            <div class="input-group-text">
                                <span style="color: mediumslateblue;">
                                    <i class="fas fa-user-tie"></i>
                                </span>
                            </div>
                        </div>
                        <input type="text" class="form-control" name="username" id="username" required>
                    </div>
                </div>

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
                        <input type="password" class="form-control" name="password" id="password" onkeyup="enableCPassword()" required>
                    </div>
                </div>

                <div class="form-group was-validated" id="c_password_group">
                    <label for="c_password">Confirm Password</label>
                    <div class="input-group mb-2">
                        <div class="input-group-prepend">
                            <div class="input-group-text">
                                <span style="color: mediumslateblue;">
                                    <i class="fas fa-key"></i>
                                </span>
                            </div>
                        </div>
                        <input type="password" pattern="/^123$/" class="form-control" name="c_password" id="c_password" onkeyup="checkPwdMatch()" disabled required>
                    </div>
                    <small style="color: red; display: none" id="password_error">Passwords do not match</small>
                </div>

                <button type="button" onclick="handleFormSubmission()" id="formSubmitBtn" class="btn btn-warning">Register</button>

            </form>

            <br>
            <br>

            <p class="text-muted">Already Registered ? <a href="index.jsp">Sign In</a></p>
        </div>

        <div class="p-2">
            <img src="./assets/img/register-big-image.jpg" style="max-height: 100vh;" alt="" class="img-fluid">
        </div>

    </div>

</body>
</html>