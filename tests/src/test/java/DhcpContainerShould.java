import helpers.DhcpdConfig;
import helpers.DockerImageTagResolver;
import helpers.HelperImages;
import io.homecentr.testcontainers.containers.GenericContainerEx;
import io.homecentr.testcontainers.containers.wait.strategy.WaitEx;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.testcontainers.containers.Container;
import org.testcontainers.containers.Network;
import org.testcontainers.containers.output.Slf4jLogConsumer;

import java.io.IOException;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

public class DhcpContainerShould {
    private static final Logger logger = LoggerFactory.getLogger(DhcpContainerRunningAsRootShould.class);

    private static GenericContainerEx _serverContainer;
    private static GenericContainerEx _clientContainer;


    @BeforeClass
    public static void setUp() throws IOException {
        Network network = Network.builder()
                .driver("bridge")
                .build();

        DhcpdConfig config = DhcpdConfig.createFromNetwork(network);

        _serverContainer = new GenericContainerEx<>(new DockerImageTagResolver())
                .withNetwork(network)
                .withFileSystemBind(config.getAbsolutePath(), "/config/dhcpd.conf")
                .waitingFor(WaitEx.forLogMessage("(.*)Socket/fallback/fallback-net(.*)", 1));

        _clientContainer = new GenericContainerEx<>(HelperImages.DhcpClient())
                .withCommand("sleep", "1000h")
                .withNetwork(network);

        _serverContainer.start();
        _serverContainer.followOutput(new Slf4jLogConsumer(logger));

        _clientContainer.start();
        _clientContainer.followOutput(new Slf4jLogConsumer(logger));
    }

    @AfterClass
    public static void cleanUp() {
        _serverContainer.close();
        _clientContainer.close();
    }

    @Test
    public void respondToDhcpDiscovery() throws IOException, InterruptedException {
        System.out.println("IP DHCP: " + _serverContainer.executeShellCommand("ip addr").getStdout());
        System.out.println("IP CLIENT: " + _clientContainer.executeShellCommand("ip addr").getStdout());

        Container.ExecResult result = _clientContainer.executeShellCommand("nmap --script broadcast-dhcp-discover");

        assertEquals(0, result.getExitCode());

        System.out.println("Nmap output:");
        System.out.println(result.getStdout());

        assertTrue(result.getStdout().contains("IP Offered:"));
    }
}
