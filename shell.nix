# Environment containing basic ROS2 tools
{
  pkgs ? import <nix-ros-overlay> {
#    overlays = [ (
#        final: prev: { 
#          rosPackages = 
#	    (
#	      prev.lib.attrsets.recursiveUpdate 
#	        prev.rosPackages
#	        {
#		  jazzy.turtlesim = 
#		  prev.rosPackages.jazzy.turtlesim.overrideAttrs { 
#	            src = ./src/ros_tutorials/turtlesim;
#                  };
#		}
#	     );
#	  }
#	)
#    ];
  },

  rosDistro ? "jazzy",
  package ? "desktop",
}:
pkgs.mkShell {
  buildInputs = [ pkgs.cmake pkgs.qt5.qtwayland ];
  packages = [
    (pkgs.rosPackages.${rosDistro}.buildEnv {
      underlay = true;
      paths = [
        pkgs.colcon
      ]
      ++ (with pkgs.rosPackages.${rosDistro}; [
        ament-cmake-core
        python-cmake-module

	ros-core

	geometry-msgs
        turtlebot4-desktop
        turtlebot4-simulator
	open-manipulator-gui
	open-manipulator-bringup
	open-manipulator
	
        slam-toolbox
        nav2-minimal-tb4-sim
        nav2-minimal-tb3-sim
        # rqt metapackages
        rqt-common-plugins
        rqt-tf-tree
        tf2-tools

        gz-gui-vendor
        gz-sim-vendor

	turtlesim
	#pkgs.rosPackages.${rosDistro}.turtlesim
        #(pkgs.rosPackages.${rosDistro}.turtlesim.overrideAttrs { src = ./src/ros_tutorials/turtlesim; })
      ]);
    })
  ];
  shellHook = ''
    # Setup ROS 2 shell completion. Doing it in direnv is useless.
    if [[ ! $DIRENV_IN_ENVRC ]]; then
        eval "$(${pkgs.python3Packages.argcomplete}/bin/register-python-argcomplete ros2)"
        eval "$(${pkgs.python3Packages.argcomplete}/bin/register-python-argcomplete colcon)"
    fi
  '';
}
