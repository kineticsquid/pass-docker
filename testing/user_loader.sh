#! /bin/sh

if [ -z $3 ]; then
  echo "user_loader.sh:  used for adding or updating user records manually"
  echo ""
  echo "Usage:  load_user.sh <user:pass> <fcrepo baseuri> <employee id> [roles]"
  echo ""
  echo "For example:"
  echo "  load_admin.sh fedoraAdmin:moo http://localhost:8080/fcrepo/rest/ 00010000"
  echo ""
  echo "Note: fcrepo baseurl must end in a slash"
  echo "Note: employee ID must be 8 digits long, pad with zeroes if necessary"
  echo "Note: by default, the user is created as a submitter."
  echo "      The optional roles argument can override this"
  echo "      Known roles are {admin, submitter}"
  echo "Note: using this on an existing user will overwrite its state"
  echo "Note: The syntax for adding multiple roles is 'admin", "submitter", "pass-backend'. "
  echo "      where the leading and trailing quotes are omitted.  This is because the script was "
  echo "      written quickly, and adds the first and last quotes"
  exit 1
fi

curl -u $1 -i -# -X PUT -H "return=representation" -H "Prefer: handling=lenient; received=\"minimal\"" -H "Content-Type: application/ld+json" --data-binary @- ${2}users/${3} <<EOF
{
  "@id" : "${2}users/${3}",
  "@type" : "User",
  "localKey" : "${3}",
  "roles" : [ "${4:-submitter}" ],
  "@context" : "https://oa-pass.github.io/pass-data-model/src/main/resources/context-2.2.jsonld"
}
EOF


