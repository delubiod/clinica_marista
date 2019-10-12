<%@page import="org.simplejavamail.mailer.MailerBuilder"%><%@page import="org.simplejavamail.email.EmailBuilder"%><%@page import="org.simplejavamail.email.Email"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="javax.net.ssl.HttpsURLConnection"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.URL"%>
<%@page import="net.sf.json.JSONObject"%><%
   
String formNome="";
String formEmail="";
String formMensagem="";

String RECAPTCHA_SITE_KEY="6LdfXpoUAAAAAL82Paw3gxfFYSrxpSiPGlynZnXK";
String RECAPTCHA_KEY_SECRET="6LdfXpoUAAAAAChf7VUGjBDaweRqCj9Z7lqFFkvo";
String recaptchaResponse = "";
float score = 0;

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

try{
    recaptchaResponse = request.getParameter("recaptchaResponse") == null ? "" : request.getParameter("recaptchaResponse").toString();
    System.out.println("cmm mailer: RecaptchaResponse:" + recaptchaResponse);
} catch (Exception e) {
    System.out.println("cmm mailer: Exceção: " + e.getMessage());
    recaptchaResponse = "";
    erro = true;
}

if (recaptchaResponse != null && ! recaptchaResponse.equals("")){
    
    try {
    
        HttpURLConnection yc =null;
        URL urlServer = null;
        String secret = RECAPTCHA_KEY_SECRET;
        urlServer = new URL("https://www.google.com/recaptcha/api/siteverify?secret=" + secret + "&response=" + recaptchaResponse);

        yc = (HttpURLConnection) urlServer.openConnection();

        int responseCode=yc.getResponseCode();

        String line;
        String resultado = "";

        if (responseCode == HttpsURLConnection.HTTP_OK || //200 ou 202
                responseCode == HttpURLConnection.HTTP_ACCEPTED ||
                responseCode == HttpURLConnection.HTTP_NOT_AUTHORITATIVE ) {
            BufferedReader bRead=new BufferedReader(new InputStreamReader(yc.getInputStream()));

            while ((line=bRead.readLine()) != null) {
                resultado+=line;
            }
            bRead.close();

        }
        else {
            resultado="";
            BufferedReader bRead=new BufferedReader(new InputStreamReader(yc.getErrorStream()));
            System.out.println(" ################# ERRO HTTP CONNECTION -------------- ");
            System.out.println(" Response Code: " + responseCode);
            while ((line=bRead.readLine()) != null) {
                System.out.println(line);
            }
            System.out.println(" ################# [end   http   error] -------------- ");
            bRead.close();

        }
        yc.disconnect();
        yc = null;
        
        System.out.println ("cmm mailer: Resultado :" + resultado);
    
        JSONObject jsonObject = new JSONObject(resultado);
        score = Float.parseFloat(jsonObject.getString("score"));
        System.out.println("cmm mailer: Score:" + score);
    } catch (Exception e) { 
        System.out.println("cmm mailer: exceção em contact-form-handler.jsp:" + e.getMessage());
        score = 0;
    }
}

if(formNome.equals("")||formEmail.equals("")||formMensagem.equals("")||recaptchaResponse.equals("")) erro = true;

if(erro==false && score > 0.5) {

    System.out.println("cmm mailer: no form errors.");

    String destino="centromedicomarista@gmail.com";
    String destino2="alrp.net@gmail.com";

    String subject="Mensagem recebida em centromedicomarista.com";
    
    String origem="centromedicomarista@gmail.com";
    
    String mensagem = "Você Recebeu Uma Nova Mensagem. \nAqui Estão os Detalhes da Mensagem:\n Nome: "+ formNome +" \n Email: " + formEmail + " \n Mensagem: \n " + formMensagem;

    try {
	    Email email = EmailBuilder.startingBlank()
	        .from("Centro Medico Marista", origem)
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
$myemail = 'alrp.net@gmail.com';//<-----Put Your email address here.
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
	$email_subject = "Formul�rio de Contato: $name";
	$email_body = "Voc� Recebeu Uma Nova Mensagem. \nAqui Est�o os Detalhes da Mensagem:\n Nome: $name \n Email: $email_address \n Mensagem: \n $message";

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
	<title>Retorne ao Formulario</title>

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
      <h1>PREENCHA TODOS OS CAMPOS <br> DO FORMULARIO</h1>

      <!--<input type="button" value="Voltar!" onclick="history.back()">-->
      <button type="button" class="btn btn-success" onclick="history.back()">RETORNAR AO SITE</button>
    </div>
  </div>
</form>

</body>
</html>
