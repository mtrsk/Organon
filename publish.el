;; package --- Summary:
;; org-publish.el --- publish related org-mode files as a website
;;; Commentary:
;;;
;;; How to run this:
;;; * eval the buffer
;;; * M-x site-publish
;;;

(require 'org)
(require 'ox-publish)
(require 'ox-html)

;;; org-babel configuration

;;;; don't ask for confirmation before evaluating a code block
(setq org-confirm-babel-evaluate nil)
(setq org-export-use-babel t)

;;; Project variables:

(defcustom out-dir "./public/" "Directory where the HTML files are going to be exported")

(setq-default root-dir (if (string= (getenv "ENVIRONMENT") "development") (concat (getenv "PWD") "/public") ""))

(setq-default website-html-head (apply 'format (concat "<script src=\"%s/static/mathjax/tex-chtml.js\" id=\"MathJax-script\" async></script>\n"
                                                       "<link rel=\"stylesheet\" href=\"%s/css/site.css\" type=\"text/css\"/>\n"
                                                       "<link rel=\"stylesheet\" href=\"%s/static/fontawesome/css/all.css\"/>\n")
                                                       (make-list 3 root-dir)))

(setq-default website-html-preamble (apply 'format (concat "<header class='header'>\n"
                                                           "  <a href=\"%s/index.html\">Home</a>\n"
                                                           "  <nav>\n"
                                                           "    <a href=\"%s/notes.html\">Notes</a>\n"
                                                           "    <a href=\"%s/posts.html\">Posts</a>\n"
                                                           "  </nav>\n"
                                                           "</header>\n")
                                           (make-list 3 root-dir)))

(setq-default website-html-postamble (concat "<div class=\"footer\"> Last updated %C."
                                             "<br> Built with %c. "
                                             "Source code availiable "
                                             "<a href=\"https://github.com/mtrsk/mtrsk.github.io\">Here</a>.</div>"))

;;; Code:

(setq org-publish-project-alist
      `(("notes"
         :base-directory ,.
         :base-extension "org"
         :publishing-directory ,out-dir
         :publishing-function org-html-publish-to-html

         :title "Stranger in a strange λ"
         :author "Marcos Benevides"
         :email "(concat \"marcos.schonfinkel\" at \"gmail.com\")"
         :with-creator t
         :recursive t

         :export-with-tags nil
         :exclude-tags ("todo" "noexport")
         :exclude "level-.*\\|.*\.draft\.org"
         :with-title t
         :section-numbers nil
         :headline-levels 5
         :with-toc nil
         :with-date t

         :auto-sitemap nil
         :sitemap-filename "index.org"
         :sitemap-title "Home"
         :sitemap-sort-files anti-chronologically
         :sitemap-file-entry-format "%d - %t"
         :sitemap-style list

         :html-doctype "html5"
         :html-html5-fancy t
         :html-head ,website-html-head
         :html-preamble ,website-html-preamble
         :html-postamble ,website-html-postamble)

        ("images"
         :base-directory "./images/"
         :base-extension "png\\|jpg\\|gif"
         :publishing-directory ,(concat out-dir "images")
         :publishing-function org-publish-attachment
         :recursive t)

        ("all" :components ("images" "notes"))))
