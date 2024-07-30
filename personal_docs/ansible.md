# Ansible

## Naming conventions
- Tasks names start with a verb
>  Use an action verb at the beginning of the task name to indicate what the role does. For example, Install Nginx or Configure firewall. Start with a capital letter. No need to end with a period for a few words of task description

- Roles names are lowercase and kebab case

- Yaml files are lowercase and snake case 
> When statements such as include are used, it is convenient to have file names with out hyphens. For example: install_web_ubuntu.yml. YAML file extension: yml instead yaml. To be consistent and succinct.

## Best practices
> Keep your roles single-purposed: Each role should have a separate responsibility and distinct functionality to conform with the separation of concerns design principle. Separate your roles based on different functionalities or technical domains.

> Roles like common or even linux-cli-tools are too generic and after a while it becomes difficult to know what to put inside this roles

> Inside a role create tasks files based on functionaly too, avoid creating files such as `fedora.yml` for tasks related to fedora, instaed in a file with a specific purpouse make a special tasks or block for fedora.

> Explicit is better than implicit. Add things like mode: '0644' even if its default

## Functionalities

### In cases of a missing module
> When missing a module, (eg. install from github releases), prefer simple solutions using default modules as, for my use case, they are better because they come preinstalled with ansible

### Using register and set_fact togheder
> The register directive is used to capture the results of the set_fact task. This is necessary because the set_fact task is run in a loop, and you need to capture the matching URLs for all iterations. By registering the results, you can then use these results in subsequent tasks, such as downloading the matching assets.
