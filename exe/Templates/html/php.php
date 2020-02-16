<html>
<head>
<title>PHP Script Example</title>

<!-- You can enclose PHP script either in 'script' HTML-tag... -->

<script LANGUAGE="php">
pval entry;  entry.type = IS_LONG;entry.value.lval = 5;  
/* defines $foo["bar"] = 5 */
hash_update(arr.value.ht,"bar",sizeof("bar"),&entry,sizeof(pval),NULL); 
/* defines $foo[7] = 5 */
hash_index_update(arr.value.ht,7,&entry,sizeof(pval),NULL); 
/* defines the next free place in $foo[], * $foo[8], to be 5 (works like php2)
 */hash_next_index_insert(arr.value.ht,&entry,sizeof(pval),NULL);

pval *resource_id;RESOURCE *resource;int type;convert_to_long(resource_id);
resource = php3_list_find(resource_id->value.lval, &type);
if (type != LE_RESOURCE_TYPE) {
    php3_error(E_WARNING,"resource index %d has the wrong type",resource_id->value.lval);
    RETURN_FALSE;}/* ...use resource... */
</script>
</head>

<BODY bgColor=#ffffff leftMargin=40 link=#500000 vLink=#505050>

<!-- or in so-called short open/close tags. -->

<?php
  if(!isset($PHP_AUTH_USER)) {
    Header("WWW-Authenticate: Basic realm=\"My Realm\"");
    Header("HTTP/1.0 401 Unauthorized");
    echo "Text to send if user hits Cancel button\n";
    exit;
  }
  else {
    echo "Hello $PHP_AUTH_USER.<P>";
    echo "You entered $PHP_AUTH_PW as your password.<P>";
  }
?>

</body>
</html>