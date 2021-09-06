#This file contains SQL updates to perform once the wordpress container is running with some customization.

DELETE FROM wp_comments where comment_ID = 1;
UPDATE wp_terms SET name = 'Success!' where term_id = 1;
UPDATE wp_posts SET comment_status = 'closed' where ID = 1;
UPDATE wp_posts SET post_title = 'Hello Luno!' where ID = 1;
UPDATE wp_options SET option_value = 'NOT Just another wordpress website.' where option_name = 'blogdescription';
UPDATE wp_posts SET post_content = '<p>This is my automated wordpress deployment using Terraform!</p> <p><img class="" src="https://d540vms5r2s2d.cloudfront.net/mad/uploads/mad_5da8679c5df481571317660.png" width="951" height="602" /></p>' where ID = 1;