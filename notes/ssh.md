
## ssh

### Check key password

To check if a password unlocks the private key, try and change it with:

```sh
ssh-keygen -f ~/.ssh/id_rsa -p
```

This will ask the current password, first. When promped for the new password,
type two mismatching ones so that it doesn't get changed.



