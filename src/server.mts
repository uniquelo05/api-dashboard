import express, { type Request, type Response } from 'express';
import cors from 'cors';
import helmet from 'helmet';

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(helmet());
app.use(express.json());

app.get('/health', (req: Request, res: Response) => {
  res.json({ status: 'ok', service: 'api-dashboard', timestamp: new Date().toISOString() });
});

app.listen(PORT, () => {
  console.log(`API Dashboard running on http://localhost:${PORT}`);
});
