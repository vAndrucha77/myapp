# Use Alpine as base
FROM ubuntu:latest

# LABEL Maintainer
LABEL maintainer="andreas@docker.com andreas.lambrecht@docker.com"

# Install curl
RUN apk --no-cache add py-pip libpq python-dev curl

# Install python and pip
RUN apk --no-cache add py2-pip

# Upgrade pip
RUN pip install --upgrade pip

# Install Python modules needed by the Python app
COPY requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt

# Copy files required for the app to run
COPY app.py /usr/src/app/
COPY templates/index.html /usr/src/app/templates/

# Expose the app on Flask default (5000)
EXPOSE 5000

# HEALTHCHECK
HEALTHCHECK CMD curl --fail http://localhost:5000 || exit 1

# Run the application
CMD ["python", "/usr/src/app/app.py"]

# Scan the image with Aqua Micro Scanner
# ADD https://get.aquasec.com/microscanner .
# RUN chmod +x microscanner
# RUN ./microscanner NWViNGYyZjJiOWFj --html > amc-output.html

# RUN apk add --update wget && apk add --no-cache ca-certificates && update-ca-certificates && \
#     wget -O /microscanner https://get.aquasec.com/microscanner && \
#     chmod +x /microscanner && \
#     /microscanner NWViNGYyZjJiOWFj --html > amc-output.html && \
#     rm -rf /microscanner
