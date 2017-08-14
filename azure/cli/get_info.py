# import subprocess

# print(subprocess.check_output(['ls', '-l']))

# 
import subprocess, json, sys

# result = subprocess.run(['ls', '-l'], stdout=subprocess.PIPE)
# print(result.stdout)
rg_name="SqlDataTools"

print(subprocess.run(['az', 'resource', 'list', '-n "SqlDataTools"'], stdout=subprocess.PIPE))
