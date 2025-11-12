# My Servlet Application

This is a simple Java Servlet application that demonstrates the use of servlets and filters in a web environment.

## Project Structure

```
my-servlet-app
├── src
│   └── main
│       ├── java
│       │   └── com
│       │       └── example
│       │           ├── servlets
│       │           │   └── HelloServlet.java
│       │           └── filters
│       │               └── LoggingFilter.java
│       └── webapp
│           ├── WEB-INF
│           │   └── web.xml
│           └── index.html
├── pom.xml
└── README.md
```

## Description

- **HelloServlet.java**: A servlet that handles GET requests and responds with a greeting message.
- **LoggingFilter.java**: A filter that logs request and response information.
- **web.xml**: The deployment descriptor that configures servlets and filters.
- **index.html**: The main entry point for the web application.

## Build and Run

To build the project, use Maven:

```
mvn clean install
```

To run the application, deploy it to a servlet container such as Apache Tomcat.

## Dependencies

This project uses Maven for dependency management. Please refer to the `pom.xml` file for the list of dependencies.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.