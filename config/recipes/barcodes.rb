# ==============================
# Barcodes
# ==============================

namespace :barcodes do

  desc <<-EOD
    Creates the upload folders unless they exist
    and sets the proper upload permissions.
  EOD
  
  task :setup, :except => { :no_release => true } do
    dirs = barcodes_dirs.map { |d| File.join(shared_path, d) }
    run "#{try_sudo} mkdir -p #{dirs.join(' ')} && #{try_sudo} chmod g+w #{dirs.join(' ')}"
  end

  desc <<-EOD
    [internal] Creates the symlink to uploads shared folder
    for the most recently deployed version.
  EOD
  task :symlink, :except => { :no_release => true } do
    run "rm -rf #{release_path}/public/barcodes"
    run "ln -nfs #{shared_path}/barcodes #{release_path}/public/barcodes"
  end

  desc <<-EOD
    [internal] Computes uploads directory paths
    and registers them in Capistrano environment.
  EOD
  task :register_dirs do
    set :barcodes_dirs,    %w(barcodes)
    set :shared_children, fetch(:shared_children) + fetch(:barcodes_dirs)
  end

  after       "deploy:finalize_update", "barcodes:symlink"
  on :start,  "barcodes:register_dirs"

end