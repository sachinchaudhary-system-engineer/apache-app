FROM httpd:2.4

RUN rm -rf /usr/local/apache2/htdocs/*


COPY code/index.html /usr/local/apache2/htdocs/index.html

EXPOSE 80

CMD ["httpd-foreground"]