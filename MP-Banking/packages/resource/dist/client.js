(() => {
  // config/config.ts
  var config = {
    Banks: [
      {
        name: "Bank",
        coords: { x: 149.78, y: -1040.95, z: 29.37 },
        blipEnabled: true
      },
      {
        name: "Bank",
        coords: { x: 150.0386, y: -1040.7106, z: 29.3741 },
        blipEnabled: true
      },
      {
        name: "Bank",
        coords: { x: 149.91, y: -1040.74, z: 29.374 },
        blipEnabled: true
      },
      {
        name: "Bank",
        coords: { x: -1212.63, y: -330.78, z: 37.59 },
        blipEnabled: true
      },
      {
        name: "Bank",
        coords: { x: -2962.47, y: 482.93, z: 15.5 },
        blipEnabled: true
      },
      {
        name: "Bank",
        coords: { x: -350.99, y: -49.99, z: 48.84 },
        blipEnabled: true
      },
      {
        name: "Bank",
        coords: { x: 1175.02, y: 2706.87, z: 37.89 },
        blipEnabled: true
      },
      {
        name: "Bank",
        coords: { x: -113.01, y: 6470.24, z: 31.43 },
        blipEnabled: true
      },
      {
        name: "Bank",
        coords: { x: 246.63, y: 223.62, z: 106 },
        blipEnabled: true
      },
      {
        name: "Bank",
        coords: { x: 314.3904, y: -279.1545, z: 54.1708 },
        blipEnabled: true
      }
    ],
    target: false,
    BankTarget: {
      coords: { x: 149.78, y: -1040.95, z: 29.37 }
    }
  };
  var config_default = config;

  // ../../node_modules/@project-error/pe-utils/lib/client/functions.js
  var RegisterNuiCB = (event, callback) => {
    RegisterNuiCallbackType(event);
    on(`__cfx_nui:${event}`, callback);
  };

  // client/client.ts
  var Delay = (time) => new Promise((resolve) => setTimeout(resolve, time));
  var isNearBank = false;
  var sleep = 1e4;
  onNet("MP-Banking:OpenClient", (cash, bank, name) => {
    SendNUIMessage({
      action: "openPage",
      data: {
        pageName: "MPBANKING",
        playerCash: cash,
        playerBank: bank,
        fullName: name
      }
    });
    SetNuiFocus(true, true);
  });
  onNet("MP-Banking:UpdateClient", (cash, bank) => {
    SendNUIMessage({
      action: "updateDataMoney",
      data: {
        newCashAmount: cash,
        newBankAmount: bank
      }
    });
  });
  onNet("MP-Banking:Management", () => {
    const source = PlayerId();
  });
  RegisterNuiCB("BankingDetails", (data, cb) => {
    const bType = data.buttonType;
    const amount = data.amount;
    const id = data.id;
    const source = GetPlayerPed(-1);
    if (bType === "withdraw") {
      emitNet("MP-Banking:withdraw", parseInt(amount));
    } else if (bType === "deposit") {
      emitNet("MP-Banking:deposit", parseInt(amount));
    } else if (bType === "transfer") {
      emitNet("MP-Banking:transfer", parseInt(amount), parseInt(id));
    }
    cb("Success");
  });
  RegisterNuiCB("closeMenu", (_, cb) => {
    SetNuiFocus(false, false);
    SendNUIMessage({
      action: "closePage",
      data: {
        pageName: "MPBANKING"
      }
    });
    cb(true);
  });
  async function Blips() {
    for (const bank of config_default.Banks) {
      if (bank.blipEnabled) {
        const blip = AddBlipForCoord(bank.coords.x, bank.coords.y, bank.coords.z);
        SetBlipSprite(blip, 108);
        SetBlipDisplay(blip, 4);
        SetBlipScale(blip, 0.8);
        SetBlipColour(blip, 2);
        SetBlipAsShortRange(blip, true);
        BeginTextCommandSetBlipName("STRING");
        AddTextComponentString(bank.name);
        EndTextCommandSetBlipName(blip);
      }
    }
  }
  Blips();
  async function BankTarget() {
    const source = PlayerPedId();
    const playerPos = GetEntityCoords(PlayerPedId(), false);
    isNearBank = false;
    for (const bank of config_default.Banks) {
      if (Vdist(playerPos[0], playerPos[1], playerPos[2], bank.coords.x, bank.coords.y, bank.coords.z) < 20) {
        sleep = 1500;
      }
      if (Vdist(playerPos[0], playerPos[1], playerPos[2], bank.coords.x, bank.coords.y, bank.coords.z) < 2.5) {
        isNearBank = true;
        sleep = 10;
        if (isNearBank && IsControlPressed(0, 38)) {
          emitNet("MP-Banking:Open", source);
          break;
        }
      }
    }
  }
  setTick(async () => {
    await Delay(sleep);
    BankTarget();
  });
})();
//# sourceMappingURL=data:application/json;base64,ewogICJ2ZXJzaW9uIjogMywKICAic291cmNlcyI6IFsiLi4vY29uZmlnL2NvbmZpZy50cyIsICIuLi8uLi8uLi9ub2RlX21vZHVsZXMvQHByb2plY3QtZXJyb3IvcGUtdXRpbHMvc3JjL2NsaWVudC9mdW5jdGlvbnMudHMiLCAiLi4vY2xpZW50L2NsaWVudC50cyJdLAogICJzb3VyY2VzQ29udGVudCI6IFsiLyogZXNsaW50LWRpc2FibGUgcHJldHRpZXIvcHJldHRpZXIgKi9cclxuLy8gY29uZmlnLnRzXHJcblxyXG5pbnRlcmZhY2UgQmFua3Mge1xyXG4gIG5hbWU6IHN0cmluZ1xyXG4gIGNvb3JkczogeyB4OiBudW1iZXI7IHk6IG51bWJlcjsgejogbnVtYmVyIH1cclxuICBibGlwRW5hYmxlZDogYm9vbGVhblxyXG59XHJcbmludGVyZmFjZSBCYW5rVGFyZ2V0IHtcclxuICBjb29yZHM6IHsgeDogbnVtYmVyOyB5OiBudW1iZXI7IHo6IG51bWJlciB9XHJcbn1cclxuXHJcbmludGVyZmFjZSBTZXJ2ZXJDb25maWcge1xyXG4gIEJhbmtzOiBCYW5rc1tdXHJcbiAgdGFyZ2V0OiBib29sZWFuXHJcbiAgQmFua1RhcmdldDogQmFua1RhcmdldFxyXG59XHJcblxyXG5jb25zdCBjb25maWc6IFNlcnZlckNvbmZpZyA9IHtcclxuICBCYW5rczogW1xyXG4gICAge1xyXG4gICAgICBuYW1lOiAnQmFuaycsXHJcbiAgICAgIGNvb3JkczogeyB4OiAxNDkuNzgsIHk6IC0xMDQwLjk1LCB6OiAyOS4zNyB9LFxyXG4gICAgICBibGlwRW5hYmxlZDogdHJ1ZSxcclxuICAgIH0sXHJcbiAgICB7XHJcbiAgICAgIG5hbWU6ICdCYW5rJyxcclxuICAgICAgY29vcmRzOiB7IHg6IDE1MC4wMzg2LCB5OiAtMTA0MC43MTA2LCB6OiAyOS4zNzQxIH0sIC8vIExlZ2lvbiBTcXVhcmUgQmFua1xyXG4gICAgICBibGlwRW5hYmxlZDogdHJ1ZSxcclxuICAgIH0sXHJcbiAgICB7XHJcbiAgICAgIG5hbWU6ICdCYW5rJyxcclxuICAgICAgY29vcmRzOiB7IHg6IDE0OS45MSwgeTogLTEwNDAuNzQsIHo6IDI5LjM3NCB9LFxyXG4gICAgICBibGlwRW5hYmxlZDogdHJ1ZSxcclxuICAgIH0sXHJcbiAgICB7XHJcbiAgICAgIG5hbWU6ICdCYW5rJyxcclxuICAgICAgY29vcmRzOiB7IHg6IC0xMjEyLjYzLCB5OiAtMzMwLjc4LCB6OiAzNy41OSB9LFxyXG4gICAgICBibGlwRW5hYmxlZDogdHJ1ZSxcclxuICAgIH0sXHJcbiAgICB7XHJcbiAgICAgIG5hbWU6ICdCYW5rJyxcclxuICAgICAgY29vcmRzOiB7IHg6IC0yOTYyLjQ3LCB5OiA0ODIuOTMsIHo6IDE1LjUgfSxcclxuICAgICAgYmxpcEVuYWJsZWQ6IHRydWUsXHJcbiAgICB9LFxyXG4gICAge1xyXG4gICAgICBuYW1lOiAnQmFuaycsXHJcbiAgICAgIGNvb3JkczogeyB4OiAtMzUwLjk5LCB5OiAtNDkuOTksIHo6IDQ4Ljg0IH0sXHJcbiAgICAgIGJsaXBFbmFibGVkOiB0cnVlLFxyXG4gICAgfSxcclxuICAgIHtcclxuICAgICAgbmFtZTogJ0JhbmsnLFxyXG4gICAgICBjb29yZHM6IHsgeDogMTE3NS4wMiwgeTogMjcwNi44NywgejogMzcuODkgfSxcclxuICAgICAgYmxpcEVuYWJsZWQ6IHRydWUsXHJcbiAgICB9LFxyXG4gICAge1xyXG4gICAgICBuYW1lOiAnQmFuaycsXHJcbiAgICAgIGNvb3JkczogeyB4OiAtMTEzLjAxLCB5OiA2NDcwLjI0LCB6OiAzMS40MyB9LFxyXG4gICAgICBibGlwRW5hYmxlZDogdHJ1ZSxcclxuICAgIH0sXHJcbiAgICB7XHJcbiAgICAgIG5hbWU6ICdCYW5rJyxcclxuICAgICAgY29vcmRzOiB7IHg6IDI0Ni42MywgeTogMjIzLjYyLCB6OiAxMDYuMCB9LFxyXG4gICAgICBibGlwRW5hYmxlZDogdHJ1ZSxcclxuICAgIH0sXHJcbiAgICB7XHJcbiAgICAgIG5hbWU6ICdCYW5rJyxcclxuICAgICAgY29vcmRzOiB7IHg6IDMxNC4zOTA0LCB5OiAtMjc5LjE1NDUsIHo6IDU0LjE3MDggfSxcclxuICAgICAgYmxpcEVuYWJsZWQ6IHRydWUsXHJcbiAgICB9LFxyXG4gIF0sXHJcbiAgdGFyZ2V0OiBmYWxzZSwgLy8gQmVsb3cgb25seSB3b3JrcyBpZiB0aGlzIGlzIHRydWVcclxuICBCYW5rVGFyZ2V0OiB7XHJcbiAgICBjb29yZHM6IHsgeDogMTQ5Ljc4LCB5OiAtMTA0MC45NSwgejogMjkuMzcgfSwgLy8gRXhhbXBsZSBsb2NhdGlvbi4gQ2hhbmdlIHRvIHlvdXIgbG9jYXRpb25cclxuICB9LFxyXG59XHJcblxyXG5leHBvcnQgZGVmYXVsdCBjb25maWdcclxuIiwgbnVsbCwgImltcG9ydCBjb25maWcgZnJvbSAnLi4vY29uZmlnL2NvbmZpZydcbmNvbnN0IERlbGF5ID0gKHRpbWU6IG51bWJlcikgPT4gbmV3IFByb21pc2UoKHJlc29sdmUpID0+IHNldFRpbWVvdXQocmVzb2x2ZSwgdGltZSkpXG5sZXQgaXNOZWFyQmFuayA9IGZhbHNlXG5sZXQgc2xlZXAgPSAxMDAwMCAvLyBkZWZhdWx0ZWQgdG8gMTAgc2VjIGl0cyBub3QgYSBiYWQgd2FpdCBpZiB5b3Ugd2VyZSB0byBnZXQgdGhlcmUgcmlnaHQgYXdheS4gSSB0aGlua1xuaW1wb3J0IHsgUmVnaXN0ZXJOdWlDQiB9IGZyb20gJ0Bwcm9qZWN0LWVycm9yL3BlLXV0aWxzJ1xuXG5vbk5ldCgnTVAtQmFua2luZzpPcGVuQ2xpZW50JywgKGNhc2g6IG51bWJlciwgYmFuazogbnVtYmVyLCBuYW1lOiBzdHJpbmcpID0+IHtcbiAgU2VuZE5VSU1lc3NhZ2Uoe1xuICAgIGFjdGlvbjogJ29wZW5QYWdlJyxcbiAgICBkYXRhOiB7XG4gICAgICBwYWdlTmFtZTogJ01QQkFOS0lORycsXG4gICAgICBwbGF5ZXJDYXNoOiBjYXNoLFxuICAgICAgcGxheWVyQmFuazogYmFuayxcbiAgICAgIGZ1bGxOYW1lOiBuYW1lLFxuICAgIH0sXG4gIH0pXG4gIFNldE51aUZvY3VzKHRydWUsIHRydWUpXG59KVxuXG5vbk5ldCgnTVAtQmFua2luZzpVcGRhdGVDbGllbnQnLCAoY2FzaDogbnVtYmVyLCBiYW5rOiBudW1iZXIpID0+IHtcbiAgU2VuZE5VSU1lc3NhZ2Uoe1xuICAgIGFjdGlvbjogJ3VwZGF0ZURhdGFNb25leScsXG4gICAgZGF0YToge1xuICAgICAgbmV3Q2FzaEFtb3VudDogY2FzaCxcbiAgICAgIG5ld0JhbmtBbW91bnQ6IGJhbmssXG4gICAgfSxcbiAgfSlcbn0pXG5cbm9uTmV0KCdNUC1CYW5raW5nOk1hbmFnZW1lbnQnLCAoKSA9PiB7XG4gIGNvbnN0IHNvdXJjZSA9IFBsYXllcklkKClcbn0pXG5cblJlZ2lzdGVyTnVpQ0IoJ0JhbmtpbmdEZXRhaWxzJywgKGRhdGEsIGNiKSA9PiB7XG4gIGNvbnN0IGJUeXBlID0gZGF0YS5idXR0b25UeXBlXG4gIGNvbnN0IGFtb3VudCA9IGRhdGEuYW1vdW50XG4gIGNvbnN0IGlkID0gZGF0YS5pZFxuICBjb25zdCBzb3VyY2UgPSBHZXRQbGF5ZXJQZWQoLTEpXG5cbiAgaWYgKGJUeXBlID09PSAnd2l0aGRyYXcnKSB7XG4gICAgZW1pdE5ldCgnTVAtQmFua2luZzp3aXRoZHJhdycsIHBhcnNlSW50KGFtb3VudCkpXG4gIH0gZWxzZSBpZiAoYlR5cGUgPT09ICdkZXBvc2l0Jykge1xuICAgIGVtaXROZXQoJ01QLUJhbmtpbmc6ZGVwb3NpdCcsIHBhcnNlSW50KGFtb3VudCkpXG4gIH0gZWxzZSBpZiAoYlR5cGUgPT09ICd0cmFuc2ZlcicpIHtcbiAgICAvLyBBc3N1bWluZyBgYW1vdW50YCBhbmQgYGlkYCBhcmUgdmFyaWFibGVzIHJlcHJlc2VudGluZyB0aGUgYW1vdW50IGFuZCBJRCB2YWx1ZXNcbiAgICBlbWl0TmV0KCdNUC1CYW5raW5nOnRyYW5zZmVyJywgcGFyc2VJbnQoYW1vdW50KSwgcGFyc2VJbnQoaWQpKVxuICB9XG5cblxuICBjYignU3VjY2VzcycpXG59KVxuXG5SZWdpc3Rlck51aUNCKCdjbG9zZU1lbnUnLCAoXywgY2IpID0+IHtcbiAgU2V0TnVpRm9jdXMoZmFsc2UsIGZhbHNlKVxuICBTZW5kTlVJTWVzc2FnZSh7XG4gICAgYWN0aW9uOiAnY2xvc2VQYWdlJyxcbiAgICBkYXRhOiB7XG4gICAgICBwYWdlTmFtZTogJ01QQkFOS0lORycsXG4gICAgfSxcbiAgfSlcblxuICBjYih0cnVlKVxufSlcblxuYXN5bmMgZnVuY3Rpb24gQmxpcHMoKSB7XG4gIC8vIGZvciBldmVyeSBiYW5rIGNvb3JkaW5hdGUgaW4gY29uZmlnLnRzIGNyZWF0ZSBhIGJsaXBcbiAgZm9yIChjb25zdCBiYW5rIG9mIGNvbmZpZy5CYW5rcykge1xuICAgIGlmIChiYW5rLmJsaXBFbmFibGVkKSB7XG4gICAgICBjb25zdCBibGlwID0gQWRkQmxpcEZvckNvb3JkKGJhbmsuY29vcmRzLngsIGJhbmsuY29vcmRzLnksIGJhbmsuY29vcmRzLnopXG4gICAgICBTZXRCbGlwU3ByaXRlKGJsaXAsIDEwOClcbiAgICAgIFNldEJsaXBEaXNwbGF5KGJsaXAsIDQpXG4gICAgICBTZXRCbGlwU2NhbGUoYmxpcCwgMC44KVxuICAgICAgU2V0QmxpcENvbG91cihibGlwLCAyKVxuICAgICAgU2V0QmxpcEFzU2hvcnRSYW5nZShibGlwLCB0cnVlKVxuICAgICAgQmVnaW5UZXh0Q29tbWFuZFNldEJsaXBOYW1lKCdTVFJJTkcnKVxuICAgICAgQWRkVGV4dENvbXBvbmVudFN0cmluZyhiYW5rLm5hbWUpXG4gICAgICBFbmRUZXh0Q29tbWFuZFNldEJsaXBOYW1lKGJsaXApXG4gICAgfVxuICB9XG59XG5CbGlwcygpXG5cbmFzeW5jIGZ1bmN0aW9uIEJhbmtUYXJnZXQoKSB7XG4gIGNvbnN0IHNvdXJjZSA9IFBsYXllclBlZElkKClcbiAgY29uc3QgcGxheWVyUG9zID0gR2V0RW50aXR5Q29vcmRzKFBsYXllclBlZElkKCksIGZhbHNlKVxuICBpc05lYXJCYW5rID0gZmFsc2VcblxuICBmb3IgKGNvbnN0IGJhbmsgb2YgY29uZmlnLkJhbmtzKSB7XG4gICAgLy8gYWRkZWQgYW5vdGhlciBjaGVjayBmb3IgZGlzdGFuY2UgdGhlbiBzZXQgc2xlZXAgbG93ZXIgdG8gY2hlY2sgZXZlcnkgMS41c2VjIFt0aGVyZSBzaG91bGQgYmUgYSBzbGlnaHQgZGVsYXkgaSBmb3VuZCB0aGlzIHByZXR0eSB3ZWxsXVxuICAgIGlmIChcbiAgICAgIFZkaXN0KHBsYXllclBvc1swXSwgcGxheWVyUG9zWzFdLCBwbGF5ZXJQb3NbMl0sIGJhbmsuY29vcmRzLngsIGJhbmsuY29vcmRzLnksIGJhbmsuY29vcmRzLnopIDxcbiAgICAgIDIwXG4gICAgKSB7XG4gICAgICBzbGVlcCA9IDE1MDBcbiAgICB9XG4gICAgaWYgKFxuICAgICAgVmRpc3QocGxheWVyUG9zWzBdLCBwbGF5ZXJQb3NbMV0sIHBsYXllclBvc1syXSwgYmFuay5jb29yZHMueCwgYmFuay5jb29yZHMueSwgYmFuay5jb29yZHMueikgPFxuICAgICAgMi41XG4gICAgKSB7XG4gICAgICBpc05lYXJCYW5rID0gdHJ1ZVxuICAgICAgc2xlZXAgPSAxMFxuICAgICAgaWYgKGlzTmVhckJhbmsgJiYgSXNDb250cm9sUHJlc3NlZCgwLCAzOCkpIHtcbiAgICAgICAgZW1pdE5ldCgnTVAtQmFua2luZzpPcGVuJywgc291cmNlKVxuICAgICAgICBicmVha1xuICAgICAgfVxuICAgIH1cbiAgfVxufVxuXG5zZXRUaWNrKGFzeW5jICgpID0+IHtcbiAgYXdhaXQgRGVsYXkoc2xlZXApXG4gIEJhbmtUYXJnZXQoKVxufSlcbiJdLAogICJtYXBwaW5ncyI6ICI7O0FBa0JBLE1BQU0sU0FBdUI7QUFBQSxJQUMzQixPQUFPO0FBQUEsTUFDTDtBQUFBLFFBQ0UsTUFBTTtBQUFBLFFBQ04sUUFBUSxFQUFFLEdBQUcsUUFBUSxHQUFHLFVBQVUsR0FBRyxNQUFNO0FBQUEsUUFDM0MsYUFBYTtBQUFBLE1BQ2Y7QUFBQSxNQUNBO0FBQUEsUUFDRSxNQUFNO0FBQUEsUUFDTixRQUFRLEVBQUUsR0FBRyxVQUFVLEdBQUcsWUFBWSxHQUFHLFFBQVE7QUFBQSxR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