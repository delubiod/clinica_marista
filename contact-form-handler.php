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
	$email_subject = "Formulário de Contato: $name";
	$email_body = "Você Recebeu Uma Nova Mensagem. \nAqui Estão os Detalhes da Mensagem:\n Nome: $name \n Email: $email_address \n Mensagem: \n $message";

	$headers = "From: $myemail\n";
	$headers .= "Reply-To: $email_address";

	mail($to,$email_subject,$email_body,$headers);
	//redirect to the 'thank you' page
	header('Location: contact-form-thank-you.html');
}
?>
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
<?php
echo nl2br($errors);
?>
<!-- End of the calling page on if it has errors -->
<form>


  <div class="center">
    <a href="/img/cirurgia.jpg">
    </a>
    <div class="box">
      <h1>PREENCHA TODOS OS CAMPOS <br> DO FORMULARIO POR FAVOR</h1>

      <input type="button" value="Voltar!" onclick="history.back()">
      
    </div>
  </div>
</form>

</body>
</html>
