<%@page import="org.simplejavamail.mailer.MailerBuilder"%><%@page import="org.simplejavamail.email.EmailBuilder"%><%@page import="org.simplejavamail.email.Email"%><%
   
String formNome="";
String formEmail="";
String formMensagem="";

boolean erro=false;

System.out.println("cmm mailer: activated.");

try{
    formNome = request.getParameter("name") != null && !request.getParameter("name").equals("") ? request.getParameter("name") : "";
    System.out.println("cmm mailer: nome: " + formNome);
} catch (Exception e) {
    System.out.println("cmm mailer: nome não enviado.");
    erro = true;
}

try{
    formEmail = request.getParameter("email") != null && !request.getParameter("email").equals("") ? request.getParameter("email") : "";
    System.out.println("cmm mailer: email: " + formEmail);
} catch (Exception e) {
    System.out.println("cmm mailer: email não enviado.");
    erro = true;
}

try{
    formMensagem = request.getParameter("message") != null && !request.getParameter("message").equals("") ? request.getParameter("message") : "";
    System.out.println("cmm mailer: mensagem: " + formMensagem);
} catch (Exception e) {
    System.out.println("cmm mailer: mensagem não enviada.");
    erro = true;
}

if(formNome.equals("")||formEmail.equals("")||formMensagem.equals("")) erro = true;

if(erro==false) {

    System.out.println("cmm mailer: no form errors.");

    String destino="centromedicomarista@gmail.com";
    String destino2="alrp.net@gmail.com";

    String subject="Mensagem recebida em centromedicomarista.com";
    
    String origem="centromedicomarista@gmail.com";
    
    String mensagem = "Você Recebeu Uma Nova Mensagem. \nAqui Estão os Detalhes da Mensagem:\n Nome: "+ formNome +" \n Email: " + formEmail + " \n Mensagem: \n " + formMensagem;

    try {
	    Email email = EmailBuilder.startingBlank()
	        .from("Centro Médico Marista", origem)
	        .to("", destino)
	        .to("", destino2)
	        .withSubject(subject)
	        .withPlainText(mensagem)
	        .buildEmail();

	    MailerBuilder
	      .withSMTPServer("smtp.gmail.com", 587, "centromedicomarista@gmail.com", "nyjjogjzjvlqxrrv")
	      .buildMailer()
	      .sendMail(email);
	    
	    response.sendRedirect("contact-form-thank-you.html");
	    return;
    } catch (Exception e) {
    	System.out.println("cmm mailer: exceção ao enviar email." + e.getMessage());
	}
}    
/*
<?php
$errors = '';
$myemail = 'delubio@delubio.tk';//<-----Put Your email address here.
if(empty($_POST['name'])  ||
   empty($_POST['email']) ||
   empty($_POST['message']))
   {
       $errors .= " ";
   }

$name = $_POST['name'];
$email_address = $_POST['email'];
$message = $_POST['message'];

if (!preg_match(
"/^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,3})$/i",
$email_address))
{
    $errors .= " ";
}

if( empty($errors))
{
	$to = $myemail;
	$email_subject = "Formulário de Contato: $name";
	$email_body = "Você Recebeu Uma Nova Mensagem. \nAqui Estão os Detalhes da Mensagem:\n Nome: $name \n Email: $email_address \n Mensagem: \n $message";

	$headers = "From: $myemail\n";
	$headers .= "Reply-To: $email_address";

	mail($to,$email_subject,$email_body,$headers);
	//redirect to the 'thank you' page
	header('Location: contact-form-thank-you.html');
}
?>
*/
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>Retorne ao Formulário</title>

  <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
  <!-- define some style elements-->

  <style>

  .center {
     background-image: url("img/cirurgia.jpg"); /* The image used
  height: 1000px;
  background-position: center; /* Center the image */
     background-repeat: no-repeat; /* Do not repeat the image */
     background-size: cover; /* Resize the background image to cover the entire container */
     overflow: hidden;
     display: flex;
     flex-direction: column;
     justify-content: top;
     align-items: center;
     text-align: center;
     margin-top:0px;
     min-height: 100vh;
  }

  h1 {
   font-size: 30px;
   color: white;

  }

  .box {
  border: 1px solid white;
  border-radius:  5px;
  padding: 20px;
  margin:350px;
  background-color: rgba(12, 184, 182, 0.71);


  }





  </style>


</head>

<body>
<!-- This page is displayed only if there is some error -->
<!-- This piece calls the page -->
<!-- End of the calling page on if it has errors -->
<form>


  <div class="center">
    <a href="/img/cirurgia.jpg">
    </a>
    <div class="box">
      <h1>PREENCHA TODOS OS CAMPOS <br> DO FORMULÁRIO</h1>

      <!--<input type="button" value="Voltar!" onclick="history.back()">-->
      <button type="button" class="btn btn-success" onclick="history.back()">RETORNAR AO SITE</button>
    </div>
  </div>
</form>

</body>
</html>
