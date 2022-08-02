const path = require("path");
const { DockerComposeEnvironment } = require("testcontainers");

describe("MailRelay container should", () => {
    var dhcpContainer;
    var composeEnvironment;

    beforeAll(async () => {
        const composeFilePath = path.resolve(__dirname, "..");

        composeEnvironment = await new DockerComposeEnvironment(composeFilePath, "docker-compose.yml")
            .withBuild()
            .up();

        dhcpContainer = composeEnvironment.getContainer("image_1");
        dhcpClient = composeEnvironment.getContainer("client_1");
    });

    afterAll(async () => {
        await composeEnvironment.down();
    });

    it("Respond on DHCP discovery request", async () => {       
        // Act
        const { output, exitCode } = await dhcpClient.exec(["nmap", "--script", "broadcast-dhcp-discover"]);

        // Assert
        expect(exitCode).toBe(0);
        expect(output).toContain("IP Offered");
    });
});