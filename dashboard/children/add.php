<?php
include("config/db_connection.php");

if(isset($_POST['add'])){
    $name = $_POST['childs_name'];

    $insert_query = "INSERT INTO Childs(childs_name) VALUES('$name')";
    $execute = mysqli_query($connection_ref, $insert_query);
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ADD CHILD</title>
</head>
<body>

<form  method="POST">

<input type="text" name="childs_name">

<button name="add">ADD</button>
</form>
    
</body>
</html>