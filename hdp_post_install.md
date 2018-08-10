# HDP Post Install Adjustments

Some Best Practice adjustments made to a cluster after all components have been installed.

## Security

### HDFS Authorization

When Ranger is installed, it will handle the first checks for authorization in HDFS.  If no rules are found in Ranger, the authorization checks against HDFS posix's permissions.

This is a source of confusion for many admins.  As a recommendation to avoid this issue, we've suggested setting all file permissions to '000' in HDFS posix.  Followed by setting the 'umask' to something like '777', which is pretty aggressive.  And has shown to lead to additional failures of services if all the appropriate permissions aren't duplicated in Ranger's HDFS Policy.

Another option is to set the Ranger HDFS setting for:

`xasecure.add-hadoop-authorization` to `false`
