const express = require('express');
const app = express();
const ldap=require("ldapjs")

function auth4(req,res,next){


const client = ldap.createClient({
  url: 'ldap://172.17.0.2:389',
});
const username = req.body.username;
const password = req.body.password;

const dn = `uid=${username},ou=users,dc=example,dc=com`;

client.bind(dn, password, (err) => {
  if (err) {
    console.error('LDAP bind failed:', err);
    res.status(500).json({ message: 'Kerberos authentication failed' });
  } else {
    console.log('LDAP bind successful!');
     next()
    // perform additional operations with the authenticated client here

    client.unbind((err) => {
      if (err) {
        console.error('LDAP unbind failed:', err);
        res.status(500).json({ message: 'Kerberos authentication failed' });
      } else {
        console.log('LDAP unbind successful!');
      }
    });
  }
});

}
app.get('/secure', auth4, (req, res) => {
  res.send(`Hello,  You have successfully accessed the secure route.`);
});

app.listen(3000, () => {
  console.log('Server is listening on port 3000');
});

