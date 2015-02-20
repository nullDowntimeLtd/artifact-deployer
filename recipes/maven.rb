if node['artifact-deployer']['install_maven']

  include_recipe "maven::default"

  m2_home         = node['maven']['m2_home']
  master_password = node['artifact-deployer']['maven']['master_password']

  repos = data_bag('maven_repos')
  maven_repos = []

  repos.each do |repo|
    repo_item = data_bag_item('maven_repos',repo)
    maven_repos.push repo_item
  end

  template  "#{m2_home}/conf/settings.xml" do
    source  "settings.xml.erb"
    mode    0666
    owner   "root"
    group   "root"
    variables(
      :repos => maven_repos
    )
  end

  if !master_password.empty?
    directory  "/root/.m2" do
      mode    0666
      owner   "root"
      group   "root"
    end

    template  "/root/.m2/settings-security.xml" do
      source  "settings-security.xml.erb"
      mode    0666
      owner   "root"
      group   "root"
    end
  end

  link "/usr/bin/mvn" do
    to "/usr/local/maven/bin/mvn"
  end
end