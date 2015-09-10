SUBDIRS = $(shell ls -l | awk '/^d/ { print $$9 }')

all:
	@list='$(SUBDIRS)'; for subdir in $$list; do \
	  echo "=============== making all in $$subdir ================="; \
	  (cd $$subdir && make && cd ../) \
	done;

install:
	@list='$(SUBDIRS)'; for subdir in $$list; do \
	  echo "============= making install in $$subdir =============="; \
	  (cd $$subdir; make install; cd ../) \
	done

uninstall:
	@list='$(SUBDIRS)'; for subdir in $$list; do \
	  echo "============= making uninstall in $$subdir =============="; \
	  (cd $$subdir; make uninstall; cd ../) \
	done

clean:
	@list='$(SUBDIRS)'; for subdir in $$list; do \
	  echo "=============== making clean in $$subdir ==============="; \
	  (cd $$subdir && make clean && cd ../) \
	done;

disclean:
	@list='$(SUBDIRS)'; for subdir in $$list; do \
	  echo "=============== making disclean in $$subdir ==============="; \
	  (cd $$subdir && make disclean && cd ../) \
	done;
